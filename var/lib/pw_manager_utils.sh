#!/bin/bash

sftp_download_file() {
    _SFTP_REMOTE_FILE=$1
    _SFTP_LOCAL_PATH=$2

    # Connect to the server and download the file
    sftp -i $SFTP_KEY -P $SFTP_PORT $SFTP_USER@$SFTP_HOST <<EOF
    get $_SFTP_REMOTE_FILE $_SFTP_LOCAL_PATH
    exit
EOF

}