Radicale
==================
*Simple, lightweight and secure Radicale container based on Alpine linux.*

![radicale](radicale.svg)

### What is Radicale ?
 Radicale is a small but powerful CalDAV (calendars, todo-lists) and CardDAV (contacts) server, that shares calendars, contacts through CalDAV, CardDAV, WebDAV and HTTP.
You can find the repository of the service [here](https://github.com/Kozea/Radicale).  

### Goal of this container
This container should be as simple as possible to set up.  
As secure as I can make it.  

### Features
- Based on Alpine linux. As lightweight as possible.
- Does not execute the server as root. As secure as possible.

### Run-time variables
- **UID**: (Optional) The UID executing the server
- **GID**: (Optional) The GID executing the server
- **ENV HTPASSWD_FILE**: filename of the htpasswd file that's used as login system. Defaults to htpasswd
- **ENV HTPASSWD_ENCRYPTION**: htpasswd file encryption type. Defaults to bcrypt.

### Volume
- **/radicale/collections**: Data folder.
- **/radicale/config**: Config folder (place your htpasswd file here).

### Ports
- 5232

### Setup
Example command to build this image:
```
docker build -t radicale .
```
[htpasswd](https://httpd.apache.org/docs/current/programs/htpasswd.html) is an apache utility that enable us to create the htpasswd files necessary to the login.  
Example command to create an htpasswd file:
```
htpasswd -c -B filename username
```
Example command to run this container:
```
docker run -d -p 80:5000 --name radicale radicale
```
You can now use [one of the existing clients](https://radicale.org/clients) to sync your calendar/contacts.
