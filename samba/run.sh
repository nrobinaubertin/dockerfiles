#!/bin/sh
su samba 
nmbd -Ds /config/smb.conf 
# < /dev/null is necessary because smbd (and nmbd too) stops if launched in foreground and receiving EOF from stdin.
smbd -FSs /config/smb.conf < /dev/null
