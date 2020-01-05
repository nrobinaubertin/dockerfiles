Syncthing
========
*Simple, lightweight and secure Syncthing container based on Alpine Linux*

![syncthing](syncthing.png)

### What is syncthing ?
Syncthing is a continuous file synchronization program. It synchronizes files between two or more computers.
You can find the original repo [here](https://github.com/syncthing/syncthing).

### Goal of this container
Propose a lightweight and secure container that is easy to setup.

### Features
- Based on Alpine Linux.
- No Root processes, as secure as possible.

### Ports
- **8384**
- **22000**
- **21027**

### Build-time variables
- **SYNCTHING_VERSION**: (Optional) version of syncthing you want to install

### Run-time variables
- **UID**: (Optional) The UID executing the server
- **GID**: (Optional) The GID executing the server

### Volume
- **/data**: Data folder.

### Setup
Build this image:
```
docker build -t syncthing .
```
Example command to run this container:
```
docker run -d -p 80:8080 -p 22000:22000 -p 21027:21027 --name syncthing syncthing
```
