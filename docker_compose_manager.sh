#!/bin/bash

# chmod +x docker_compose_manager.sh
BASEDIR=$(dirname "$(realpath "$0")")

# Define the path to your docker-compose.yml file
COMPOSE_FILE="./docker-compose.yml"

install_cert() {
    # Mute the output of the .env file
    source $BASEDIR"/.env" 2>/dev/null

    cd $BASEDIR"/docker/services/nginx/certs"

    rm *.pem
    
    echo "Generating SSL certificate for $NGINX_SERVER_NAME"
    # Generate the certificate and private key
    mkcert $NGINX_SERVER_NAME

    # Rename the certificate and private key
    cp "${NGINX_SERVER_NAME}.pem" public-key.pem
    cp "${NGINX_SERVER_NAME}-key.pem" private-key.pem
}

install_wp() {
    # Your WordPress installation code here
    docker compose -f $COMPOSE_FILE run --rm wp_install /var/www/scripts/wp_install.sh
}

generate_data_wp() {
    # Your WordPress installation code here
    docker compose -f $COMPOSE_FILE run --rm wp_install /var/www/scripts/wp_generate_data.sh
}

# Check the command line argument
case $1 in
    up)
        echo "Starting services..."
        if [ "$2" == "--build" ]; then
            docker compose -f $COMPOSE_FILE up --build
        else
            docker compose -f $COMPOSE_FILE up # -d
        fi
        ;;
    down)
        echo "Stopping services..."
        docker compose -f $COMPOSE_FILE down
        ;;
    install-cert)
        install_cert
        ;;
    install-wp)
        install_wp
        ;;
    generate-data)
        generate_data_wp
        ;;
    *)
        echo "Usage: $0 {up [--build]|down|install-cert|install-wp|generate-data}"
        exit 1
esac