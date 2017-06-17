NGINX-PHP
=========
*Simple, lightweight and secure nginx with php-fpm docker container based on Alpine Linux*

![nginx-php](nginxphp.png)

### What is nginx ? What is php ?
[Nginx](http://nginx.org/) is a web server and [php](http://php.net/) is a popular general-purpose scripting language that is especially suited to web development.

### Goal of this container
This is an attempt to have nginx and php inside one lightweight container. It should be easy to use and as secure as possible.

### Features
- Based on Alpine Linux.
- No Root processes, as secure as possible.
- Easy to add php extensions.

### Build-time variables
- **PHP_EXT**: (Optional) additional php extensions to install. They can be choosed [here](https://pkgs.alpinelinux.org/packages?name=php7-*).

### Run-time variables
- **UID**: (Optional) The UID executing the server
- **GID**: (Optional) The GID executing the server

### Ports
- **8080**

### Volume
- **/www**: Web content folder.

### Setup
Example command to build this image:
```
docker build --build-arg PHP_EXT="php7-imagick php7-mbstring" -t nginx-php .
```
Example command to run this container:
```
docker run --init -d -p 80:8080 -v /path/to/your/web/directory:/www --name nginx-php nginx-php
```
