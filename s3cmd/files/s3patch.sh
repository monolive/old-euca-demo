#!/bin/bash

cd /usr/bin
patch s3cmd < /tmp/s3cmd.patch

cd /usr/lib/python2.6/site-packages/S3
patch -p1 < /tmp/S3.patch

touch /tmp/patch_done
