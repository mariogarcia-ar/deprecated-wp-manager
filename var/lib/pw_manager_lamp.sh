#!/bin/bash

lamp_emit_cert() {
    echo "Generating SSL certificate for $NGINX_SERVER_NAME"

    #check if mkcert is installed
    if ! command -v mkcert &> /dev/null
    then
        echo "mkcert could not be found"
        echo "Please install mkcert and run this command again"
        exit
    fi

    cd $PW_SERVICES_DIR"/nginx/certs"

    # Remove the existing certificate and private key
    rm *.pem

    # Generate the certificate and private key
    mkcert $NGINX_SERVER_NAME

    # Rename the certificate and private key
    cp "${NGINX_SERVER_NAME}.pem" public-key.pem
    cp "${NGINX_SERVER_NAME}-key.pem" private-key.pem

    echo "SSL certificate generated successfully for $NGINX_SERVER_NAME in $PW_SERVICES_DIR/nginx/certs/"
}

lamp_download_backup() {
    echo "Downloading the backup from the remote server ..."

    # check if backup-prod.tar.gz exists
    if [ -f "$PW_TMP_DIR/backup-prod.tar.gz" ]; then
        echo "Backup already exists. Skipping download."
    else
        # Download the backup from the remote server
        sftp_download_file "$SFTP_REMOTE_FILE" "$PW_TMP_DIR/backup-prod.tar.gz"
    fi

    # Unzip the backup
    cd "$PW_TMP_DIR"
    # unzip -o "$PW_TMP_DIR/backup-prod.tar.gz" #-d "./var/tmp/home/amestienda.com.ar/"
    sudo mkdir -p $PW_SHARED_DIR"/backup-prod/"
    sudo tar -xzf "$PW_TMP_DIR/backup-prod.tar.gz" -C $PW_SHARED_DIR"/backup-prod/"

    echo "Backup downloaded successfully. Files are located in $PW_SHARED_DIR/backup-prod/"

    # sudo mkdir -p $PW_SHARED_DIR"/backup-prod/" #2>/dev/null
    # sudo cp -r $PW_TMP_DIR"/home/amestienda.com.ar/backup-prod" $PW_SHARED_DIR
    # echo "Backup downloaded successfully. Files are located in $PW_SHARED_DIR/backup-prod/"
}
