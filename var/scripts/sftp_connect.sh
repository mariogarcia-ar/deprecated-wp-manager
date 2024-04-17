#!/bin/bash

# Define server details
SFTP_HOST="149.50.139.129"
SFTP_PORT="5518"
SFTP_USER="prodt7011"
SFTP_KEY="~/.ssh/id_rsa"

# Define the remote file to download
REMOTE_FILE="/path/to/remote/file"

# Define the local path where the file will be downloaded
LOCAL_PATH="/path/to/local/directory"

# Connect to the server and download the file
sftp -i $SFTP_KEY -P $SFTP_PORT $SFTP_USER@$SFTP_HOST <<EOF
get $REMOTE_FILE $LOCAL_PATH
exit
EOF