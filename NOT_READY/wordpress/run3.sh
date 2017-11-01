#!/bin/sh

sleep 10
mysqladmin -u root password "root"
mysqladmin -u root --password="root" create "wordpress"
