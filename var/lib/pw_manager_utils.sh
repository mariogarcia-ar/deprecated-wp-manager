#!/bin/bash

_sftp_download_file() {
    _SFTP_REMOTE_FILE=$1
    _SFTP_LOCAL_PATH=$2

    # Connect to the server and download the file
    sftp -i "$SFTP_KEY" -P "$SFTP_PORT" "$SFTP_USER"@"$SFTP_HOST" <<EOF
    get $_SFTP_REMOTE_FILE $_SFTP_LOCAL_PATH
    exit
EOF

}

sftp_download_file() {
    # _sftp_download_file $1 $2
    if [ -f "$2" ]; then
        echo "Backup already exists. Skipping download."
    else
        # Download the backup from the remote server
        _sftp_download_file "$1" "$2"
    fi
}

sftp_download_folder() {
    _SFTP_REMOTE_FOLDER=$1
    _SFTP_LOCAL_PATH=$2

    # Connect to the server and download the folder
    sftp -i "$SFTP_KEY" -P "$SFTP_PORT" "$SFTP_USER"@"$SFTP_HOST" <<EOF
    get -r $_SFTP_REMOTE_FOLDER $_SFTP_LOCAL_PATH
    exit
EOF

}