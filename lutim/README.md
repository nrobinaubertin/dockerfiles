Lutim
========
*Simple, lightweight and secure Lutim container based on Alpine Linux*

![lutim](lutim.png)

### What is lutim ?
Lutim stores images and allows you to see them, download them or share them on social networks.
You can find their repo [here](https://framagit.org/luc/lutim).

### Goal of this container
Propose a lightweight and secure container that is easy to setup.

### Features
- Based on Alpine Linux.
- No Root processes, as secure as possible.

### Build-time variables
- **CONTACT**: (Optional) The contact email displayed on the website
- **MAX_FILE_SIZE**: (Optional) The maximum file size of a file in bytes
- **MAX_DELAY**: (Optional) Waiting delay between two uploads
- **UID**: (Optional) The UID executing the server
- **GID**: (Optional) The GID executing the server

### Ports
- **8080**

### Volumes
- **/lutim/data**: directory where the database is stored
- **/lutim/files**: directory where the files are stored

### Setup
Build this image:
```
docker build -t lutim .
```
Example command to run this container:
```
docker run -d -p 80:8080 --name lutim lutim
```
