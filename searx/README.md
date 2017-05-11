Searx
=====
*Simple and lightweight searx docker container based on alpine linux.*

![searx](https://i.goopics.net/ls.png)

#### What is searx?
Searx is a metasearch engine, inspired by the seeks project.
It provides basic privacy by mixing your queries with searches on other platforms without storing search data. Queries are made using a POST request on every browser (except chrome*). Therefore they show up in neither our logs, nor your url history. In case of Chrome* users there is an exception, Searx uses the search bar to perform GET requests. Searx can be added to your browser's search bar; moreover, it can be set as the default search engine. 
You can find the repository of the service [here](https://github.com/asciimoo/searx)

### Features
- Based on Alpine Linux. As lightweight as possible
- Does not execute as root. As secure as possible.

### Build-time variables
- **IMAGE_PROXY** : enables images proxying *(default : False)*
- **BASE_URL** : http://domain.tld *(default : False)*
- **UID** : (Optional) The UID executing the server
- **GID** : (Optional) The GID executing the server

### Ports
- 8888

### Setup
Example command to build this image:
```
docker build -t searx .
```
Example command to run this container :
```
docker run -d -p 8888:8888 -e BASE_URL=https://searx.example.com --name searx searx
```
