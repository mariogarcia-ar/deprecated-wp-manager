#!/bin/bash
BASEDIR=$(dirname "$(realpath "$0")")

source $BASEDIR"/.env" 2>/dev/null

echo "Running sftp -i $SFTP_KEY -P $SFTP_PORT $SFTP_USER@$SFTP_HOST"

# Connect to the server and download the file
sftp -i $SFTP_KEY -P $SFTP_PORT $SFTP_USER@$SFTP_HOST <<EOF
get $SFTP_REMOTE_FILE $SFTP_LOCAL_PATH
exit
EOF

echo "File downloaded to $SFTP_LOCAL_PATH"

# unzip the file
unzip $SFTP_LOCAL_PATH"/backup-prod.zip" -d $SFTP_LOCAL_PATH

echo "File unzipped to $SFTP_LOCAL_PATH"
