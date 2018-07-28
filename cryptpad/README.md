Cryptpad
========
*Simple, lightweight and secure Cryptpad container based on Alpine Linux*

![cryptpad](cryptpad.jpg)

### What is cryptpad ?
CryptPad is the zero knowledge realtime collaborative editor. Encryption carried out in your web browser protects the data from the server, the cloud and the NSA. This project uses the CKEditor Visual Editor and the ChainPad realtime engine. The secret key is stored in the URL fragment identifier which is never sent to the server but is available to javascript so by sharing the URL, you give authorization to others who want to participate.  
You can find their repo [here](https://github.com/xwiki-labs/cryptpad).

### Goal of this container
Propose a lightweight and secure container that is easy to setup.

### Features
- Based on Alpine Linux.
- No Root processes, as secure as possible.

### Build-time variables
- **DOMAIN**: The domain name where cryptpad is hosted
- **UID**: (Optional) The UID executing the server
- **GID**: (Optional) The GID executing the server

### Ports
- **3000**

### Volumes
- **/cryptpad/datastore**: directory where the encrypted data is stored
- **/cryptpad/customize**: customization directory

### Setup
Build this image:
```
docker build -t cryptpad .
```
Example command to run this container:
```
docker run -d -p 3000:3000 -e DOMAIN=https://cryptpad.example.com --name cryptpad cryptpad
```
