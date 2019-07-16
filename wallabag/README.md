Wallabag
========
*Simple and secure Wallabag container based on Alpine Linux*

![wallabag](wallabag.jpg)

### What is wallabag ?
[Wallabag](https://github.com/wallabag/wallabag) is a self hostable application for saving web pages, freely.

### Goal of this container
Propose a lightweight and secure container that is easy to setup. There is no confirmation email and I'm using the sqlite database.  
**Warning:** Support for SQLite is being [dropped](https://github.com/wallabag/wallabag/issues/2766) by Wallabag in the [future](https://github.com/wallabag/wallabag/issues/2766#issuecomment-352359471) (or maybe [later](https://github.com/wallabag/wallabag/issues/2766#issuecomment-490918115)). Since I don't really care about migrating my articles and I don't want to add a full-fledge database for this service, I'll do migrations manually.
**Warning:** This container will stay on alpine 3.9 until wallabag 2.4 ([php 7.3 is not supported by 2.3.x](https://github.com/wallabag/wallabag/issues/3899)).

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
docker run -d -p 80:8080 -v /path/to/your/data/directory:/wallabag/data --name wallabag wallabag
```
