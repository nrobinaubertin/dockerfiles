Alltube
========
*Simple, lightweight and secure Alltube container based on Alpine Linux*

![alltube](alltube.png)

### What is alltube ?
Alltube is basically an HTML GUI for [youtube-dl](https://rg3.github.io/youtube-dl/). It allows an easy download of music and videos from various sources around the web.
You can find the original repo [here](https://github.com/Rudloff/alltube/).

### Goal of this container
Propose a lightweight and secure container that is easy to setup.

### Features
- Based on Alpine Linux.
- No Root processes, as secure as possible.

### Ports
- **8080**

### Setup
Build this image:
```
docker build -t alltube .
```
Example command to run this container:
```
docker run -d --init -p 80:8080 --name alltube alltube
```
