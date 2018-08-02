#!/usr/bin/env python3

import os
import docker
import time

if os.geteuid() != 0:
    exit("You need to have root privileges to run this script.")

APIClient = docker.APIClient(base_url="unix://var/run/docker.sock")
last_time = 0
for event in APIClient.events(filters={"event":"start"}, since=(time.time() - 1000), until=time.time(), decode=True):
    if event["time"] > last_time:
        last_time = event["time"]
print(last_time)
