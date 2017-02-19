Samba
=====
*Simple, lightweight and secure Samba docker container, based on Alpine Linux.*

![samba logo](https://upload.wikimedia.org/wikipedia/commons/e/e8/Samba_Logo.png)

### what is Samba ?
Samba is a re-implementation of the SMB networking protocol. It facilitates file and printer sharing among Linux and Windows systems as an alternative to NFS.

### Goal of this container
I am trying really hard to make a drop-in container, as simple as possible to setup.  
Only one shared folder with all permissions to anybody on the local network : perfect for family use.

### Features
- Based on Alpine Linux.
- Automatic installation for drop-in use.
- No root processes. As secure as possible.

### Build-time variables
- **USERNAME** : The username used for samba (needs to have read/write rights on the host shared directory) 

### Ports
I'm not using the standard ports inside the container in order to not run samba as root.  
But it shouldn't be a issue since you can bind them to the usual ones at run (see setup example).  
- 7137 
- 7138 
- 7139 
- 7445

### Volumes
- **/shared** : Shared folder.

### Setup
Example command to build this image :
```
docker build -t samba .
```
Example command to run this container :
```
docker run -d -p 137-139:7137-7139 -p 445:7445 -v /path/to/share/:/shared --name=samba samba
```
