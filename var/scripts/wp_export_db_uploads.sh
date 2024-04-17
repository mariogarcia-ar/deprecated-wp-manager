#!/bin/bash

# This script is used to backup the database and uploads folder of a WordPress site.

# Create a directory to store the backups
mkdir -p ~/backup-prod/

# Backup the database
cd ~/public_html
wp db export ~/backup-prod/amestienda.com.ar.sql

# Backup the uploads folder
cd ~/public_html/wp-content/
find ./uploads -type f |  grep  -v -E '\-[[:digit:]]{1,4}x[[:digit:]]{1,4}' | tar -T - -cf - | tar -C  ~/backup-prod/ -xf -

# Compress the backup
cd ~
zip -r backup-prod.zip ~/backup-prod/
rm -rf ~/backup-prod/

# Copy the backup to a remote server
LOCAL_DIR="./backup-prod.zip"
REMOTE_DIR="dw_prodtco:~/amestienda.com.ar/"
rsync -avz $LOCAL_DIR $REMOTE_DIR
