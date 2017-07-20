#!/bin/sh

su-exec samba:samba /bin/s6-svscan /etc/s6.d
