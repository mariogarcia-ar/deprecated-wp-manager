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