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
    cd $BASEDIR
    # Your WordPress installation code here
    docker compose -f $COMPOSE_FILE run --rm wp_install /var/www/scripts/wp_install.sh
}

generate_data_wp() {
    cd $BASEDIR
    # Your WordPress installation code here
    docker compose -f $COMPOSE_FILE run --rm wp_install /var/www/scripts/wp_generate_data.sh
}

reset_db_wp() {
    cd $BASEDIR
    # Your WordPress installation code here
    docker compose -f $COMPOSE_FILE run --rm wp_install /var/www/scripts/wp_db_reset.sh
}

import() {
    cd $BASEDIR"/docker/services/wp/plugins"
    rm pw_wp_importer.zip
    zip -r pw_wp_importer.zip pw_wp_importer

    cd $BASEDIR
    #Install 
    docker compose -f $COMPOSE_FILE run --rm wp_cmd plugin delete pw_wp_importer
    docker compose -f $COMPOSE_FILE run --rm wp_cmd plugin install /var/www/plugins/pw_wp_importer.zip  --activate

    # Test

    # Taxonomies, categories and tags
    docker compose -f $COMPOSE_FILE run --rm wp_cmd pw_importer category  "./wp-content/plugins/pw_wp_importer/data/category.csv"
    docker compose -f $COMPOSE_FILE run --rm wp_cmd pw_importer tag  "./wp-content/plugins/pw_wp_importer/data/tag.csv"
    docker compose -f $COMPOSE_FILE run --rm wp_cmd pw_importer taxonomy  "./wp-content/plugins/pw_wp_importer/data/taxonomy.csv" category

    # Users
    docker compose -f $COMPOSE_FILE run --rm wp_cmd pw_importer user  "./wp-content/plugins/pw_wp_importer/data/user.csv"

    # Attachment
    docker compose -f $COMPOSE_FILE run --rm wp_cmd pw_importer attachment  "./wp-content/plugins/pw_wp_importer/data/attachment.csv"

    # Post
    docker compose -f $COMPOSE_FILE run --rm wp_cmd pw_importer post  "./wp-content/plugins/pw_wp_importer/data/post.csv"
    docker compose -f $COMPOSE_FILE run --rm wp_cmd pw_importer post_meta  "./wp-content/plugins/pw_wp_importer/data/post_meta.csv"
    docker compose -f $COMPOSE_FILE run --rm wp_cmd pw_importer thumbnail  "./wp-content/plugins/pw_wp_importer/data/thumbnail.csv"

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
    reset-db)
        reset_db_wp
        ;;  
    import-data)
        import
        ;;        
    *)
        echo "Usage: $0 {up [--build]|down|install-cert|install-wp|generate-data|reset-db|import-data}"
        exit 1
esac