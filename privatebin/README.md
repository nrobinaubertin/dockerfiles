Privatebin
==================
*Simple, lightweight and secure Privatebin container based on Alpine linux.*

![privatebin](privatebin.svg)

### What is Privatebin ?
PrivateBin is a minimalist, open source online pastebin where the server has zero knowledge of pasted data.
You can find the repository of the service [here](https://github.com/PrivateBin/PrivateBin).  

### Goal of this container
This container should be as simple as possible to set up.  
File upload is not enabled for reduced disk usage.  

### Features
- Based on Alpine linux. As lightweight as possible.
- Does not execute the server as root. As secure as possible.
- No complex configuration. As simple as possible.

### Run-time variables
- **UID**: (Optional) The UID executing the server
- **GID**: (Optional) The GID executing the server

### Ports
- 8080

### Setup
Example command to build this image:
```
docker build -t privatebin .
```
Example command to run this container:
```
docker run -d -p 80:8080 --name privatebin privatebin
```
