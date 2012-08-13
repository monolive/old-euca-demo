#!/bin/bash
mkdir -p /var/www/html/zenphoto/albums/Eucalyptus
s3cmd get s3://zenphoto/* /var/www/html/zenphoto/albums/Eucalyptus
chown -R apache:apache /var/www/html/zenphoto/albums/Eucalyptus
