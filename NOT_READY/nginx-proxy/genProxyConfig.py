#!/usr/bin/env python3

import os
import docker

if os.geteuid() != 0:
    exit("You need to have root privileges to run this script.")

# get the client for the docker API
APIClient = docker.APIClient(base_url="unix://var/run/docker.sock")

# create a list of containers
containers = []
for container in APIClient.containers():
    data = APIClient.inspect_container(container["Id"])

    ports = data["NetworkSettings"]["Ports"]
    bindings = {}
    for key,value in ports.items():
        bindings[key.split("/")[0]] = value[0]["HostPort"] if value is not None else None

    env = data["Config"]["Env"]
    env_vars = {}
    for var in env:
        env_vars[var.split("=")[0]] = var.split("=")[1]

    ip = data["NetworkSettings"]["IPAddress"]
    name = data["Name"].split("/")[1]
    containers.append({"name":name, "ip":ip, "ports": bindings, "env": env_vars})

# create the proxy configuration for nginx
config = ""
for container in containers:
    # only add a server when VIRTUAL_HOST is defined
    if "VIRTUAL_HOST" in container["env"]:
        exposed_port = None
        # let's take the first unbinded port as exposed port
        for container_port,host_port in container["ports"].items():
            if host_port is None:
                exposed_port = container_port
                break
        if exposed_port is not None:
            if "HTTP_ONLY" in container["env"] and container["env"]["HTTP_ONLY"] == "true":
                listen = "8080"
                tls = ""
            else:
                listen = "8443 http2"
                tls = "include tls.conf;\n"

            server_names = "server_name"
            for server_name in container["env"]["VIRTUAL_HOST"].split(";"):
                server_names += " " + server_name

            server = "\
            # " + container["name"] + "\n\
            server {\n\
                listen " + listen + ";\n\
                " + server_names + ";\n\
                " + tls + "\n\
                location / {\n\
                    proxy_set_header Host $http_host;\n\
                    proxy_set_header X-Forwarded-Proto $scheme;\n\
                    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\n\
                    proxy_set_header X-Real-IP $remote_addr;\n\
                    proxy_set_header Upgrade $http_upgrade;\n\
                    proxy_set_header Connection \"upgrade\";\n\
                    proxy_redirect off;\n\
                    proxy_read_timeout 120;\n\
                    proxy_connect_timeout 10;\n\
                    \n\
                    proxy_pass http://" + container["ip"] + ":" + exposed_port + "/;\n\
                }\n\
            }\n\
            "
            config = config + "\n" + server

print(config)
