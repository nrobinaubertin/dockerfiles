Tiddlywiki
========
*Simple, lightweight and secure Tiddlywiki container based on Alpine Linux*

![tiddlywiki](tiddlywiki.png)

### What is Tiddlywiki ?
[TiddlyWiki](https://github.com/Jermolene/TiddlyWiki5) is a complete interactive wiki in JavaScript. It can be used as a single HTML file in the browser or as a powerful Node.js application. It is highly customisable: the entire user interface is itself implemented in hackable WikiText.

### Goal of this container
Propose a lightweight and secure container that is easy to setup.

### Features
- Based on Alpine Linux.
- No Root processes, as secure as possible.

### Ports
- **8080**

### Build-time variables
- **TIDDLYWIKI_VERSION**: (Optional) version of Tiddlywiki you want to install

### Run-time variables
- **UID**: (Optional) The UID executing the server
- **GID**: (Optional) The GID executing the server
- **USER**: (Optional) The login of the user
- **PASSWORD**: (Optional) The password of the user

### Volume
- **/data**: Data folder.

### Setup
Build this image:
```
docker build -t tiddlywiki .
```
Example command to run this container:
```
docker run -d -p 80:8080 --name tiddlywiki tiddlywiki
```
