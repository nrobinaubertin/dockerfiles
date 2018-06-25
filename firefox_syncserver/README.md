Firefox SyncServer
==================
*Simple, lightweight and secure SyncServer container based on Alpine linux.*

![firefox syncserver](sync.png)

### What is Firefox SyncServer ?
This is an all-in-one package for running a self-hosted Firefox Sync server. It bundles the "tokenserver" project for authentication and the "syncstorage" project for storage, produce a single stand-alone webapp.  
You can find the repository of the service [here](https://github.com/mozilla-services/syncserver).  

### Goal of this container
This container should be as simple as possible to set up.  
It does not requires any volumes since your browser keeps the data during downtime.  
As secure as I can make it.  

### Features
- Based on Alpine linux. As lightweight as possible.
- Does not execute the server as root. As secure as possible.
- No volumes or complex configuration. As simple as possible.

### Build-time variables
- **URL**: The url that your browser sees. For example: https://sync.example.com
- **FORCE_WSGI**: (Optional) Set to "true" to resolve a mismatch between a public url and the application url.
- **UID**: (Optional) The UID executing the server
- **GID**: (Optional) The GID executing the server

### Ports
- 5000

### Setup
Example command to build this image:
```
docker build -t sync .
```
Example command to run this container:
```
docker run --init -d -p 5000:5000 -e URL=https://sync.example.com --name sync sync
```
You can now open a new tab in firefox, go to about:config, search for the identity.sync.tokenserver.uri preference and change the value to https://sync.example.com:5000/token/1.0/sync/1.5  
Firefox should now sync with your server.
