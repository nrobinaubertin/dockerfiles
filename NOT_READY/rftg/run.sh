#!/bin/bash

/etc/init.d/mysql start
exec ./rftgserver
