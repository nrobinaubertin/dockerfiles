Freshrss
========
*Simple, lightweight and secure Freshrss container based on Alpine Linux*

![freshrss](freshrss.png)

### What is freshrss ?
FreshRSS is a lightweight, easy to work with, powerful and customizable self-hosted RSS feed aggregator.  
You can find the original repo [here](https://github.com/FreshRSS/FreshRSS).

### Goal of this container
Propose a lightweight and secure container that is easy to setup.

### Features
- Based on Alpine Linux.
- No Root processes, as secure as possible.
- Automatic installation of a [youtube plugin](https://github.com/kevinpapst/freshrss-youtube) to view videos in your feed.

### Ports
- **8080**

### Build-time variables
- **FRESHRSS_VERSION**: (Optional) version of freshrss you want to install
- **FRESHRSS_YOUTUBE**: (Optional) version of freshrss's youtube plugin you want to install

### Run-time variables
- **UID**: (Optional) The UID executing the server
- **GID**: (Optional) The GID executing the server

### Volume
- **/freshrss/data**: Data folder.

### Setup
Build this image:
```
docker build -t freshrss .
```
Example command to run this container:
```
docker run -d -p 80:8080 --name freshrss freshrss
```
