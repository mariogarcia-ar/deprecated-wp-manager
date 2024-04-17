#!/bin/bash

wp db export oldsite.sql

tar -czf oldsite.tar.gz .

rsync -avz oldsite.sql oldsite.tar.gz user@newserver:/path/to/new/directory

tar -xzf oldsite.tar.gz

wp db create

wp db import oldsite.sql

wp option update home 'http://newdomain.com'
wp option update siteurl 'http://newdomain.com'


# ------------------

# Define local and remote directories
LOCAL_DIR="/path/to/local/directory"
REMOTE_DIR="user@hostname:/path/to/remote/directory"

# Use rsync to copy files from local to remote directory
rsync -avz $LOCAL_DIR $REMOTE_DIR

# SSH into the remote server
ssh amest2032@66.97.35.68 -p 5260

# Test access from ames
ssh dw_prodtco

# Copy a test folder
LOCAL_DIR="./backup-prod"
REMOTE_DIR="amest2032@66.97.35.68:/path/to/remote/directory"

rsync -avz $LOCAL_DIR $REMOTE_DIR