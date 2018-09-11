Wallabag
========
*Simple and secure Wallabag container based on Alpine Linux*

![wallabag](wallabag.jpg)

### What is wallabag ?
[Wallabag](https://github.com/wallabag/wallabag) is a self hostable application for saving web pages, freely.

### Goal of this container
Propose a lightweight and secure container that is easy to setup. There is no confirmation email and I'm using the sqlite database.

### Features
- Based on Alpine Linux.
- No Root processes, as secure as possible.

### Build-time variables
- **WALLABAG_VERSION**: (Optional) version of wallabag you want to install

### Run-time variables
- **DOMAIN**: The domain on which you are hosting your wallabag (like https://wallabag.example.com)
- **UID**: (Optional) The UID executing the server
- **GID**: (Optional) The GID executing the server

### Ports
- **8080**

### Volume
- **/wallabag/data**: Data folder.

### Setup
Build this image:
```
docker build -t wallabag .
```
Example command to run this container:
```
docker run -d -p 8080:8080 -v /path/to/your/data/directory:/wallabag/data --name wallabag wallabag
```
