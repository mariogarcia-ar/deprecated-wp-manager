#!/bin/bash
# chmod +x docker_compose_manager.sh
BASEDIR=$(dirname "$(realpath "$0")")

# load the .env file
source $BASEDIR"/.env" 2>/dev/null


# Define the wp_cmd and wp_install commands
wp_cmd="docker compose -f $BASEDIR/docker-compose.yml run --rm wp_cmd"
wp_install="docker compose -f $BASEDIR/docker-compose.yml run --rm wp_install"

# Define the path to your docker-compose.yml file
COMPOSE_FILE="./docker-compose.yml"

install_cert() {
    cd $BASEDIR"/var/docker/services/nginx/certs"

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
    $wp_install /var/www/scripts/wp_install.sh
}

generate_data_wp() {
    cd $BASEDIR
    # Your WordPress installation code here
    $wp_install /var/www/scripts/wp_generate_data.sh
}

reset_db_wp() {
    cd $BASEDIR
    # Your WordPress installation code here
    $wp_install /var/www/scripts/wp_db_reset.sh
}

build_plugin() {
    cd $BASEDIR"/var/docker/services/wp/plugins"
    rm pw_wp_importer.zip
    zip -r pw_wp_importer.zip pw_wp_importer
}

# ./pw_manager.sh import-data "/var/www/data"
import() {
    DATA_DIR="/var/www/data" #$1
    
    build_plugin

    cd $BASEDIR
    #Install 
    $wp_cmd plugin delete pw_wp_importer
    $wp_cmd plugin install /var/www/plugins/pw_wp_importer.zip  --activate

    # Test

    # Taxonomies, categories and tags
    $wp_cmd pw_importer category  "${DATA_DIR}/category.csv"
    $wp_cmd pw_importer tag  "${DATA_DIR}/tag.csv"
    $wp_cmd pw_importer taxonomy  "${DATA_DIR}/taxonomy.csv" category

    # Users
    $wp_cmd pw_importer user  "${DATA_DIR}/user.csv"

    # Attachment
    $wp_cmd pw_importer attachment  "${DATA_DIR}/attachment.csv"

    # Post
    $wp_cmd pw_importer post  "${DATA_DIR}/post.csv"
    $wp_cmd pw_importer post_meta  "${DATA_DIR}/post_meta.csv"
    $wp_cmd pw_importer thumbnail  "${DATA_DIR}/thumbnail.csv"

}

download_backup_prod() {
    # Connect to the server and download the file
    sftp -i $SFTP_KEY -P $SFTP_PORT $SFTP_USER@$SFTP_HOST <<EOF
    get $SFTP_REMOTE_FILE $SFTP_LOCAL_PATH
    exit
EOF

    echo "File downloaded to $SFTP_LOCAL_PATH"

    # unzip the file
    unzip $SFTP_LOCAL_PATH"/backup-prod.zip" -d $SFTP_LOCAL_PATH

    echo "File unzipped to $SFTP_LOCAL_PATH"

    mkdir ./var/backup-prod/ 2>/dev/null
    mv ./var/tmp/home/amestienda.com.ar/backup-prod/*   ./var/backup-prod/  
}


regenerate_thumbnails() {
    # regenerate-thumbnails/
    cd $BASEDIR

    # # Install regenerate-thumbnails plugin
    # $wp_cmd plugin delete "regenerate-thumbnails"
    # $wp_cmd plugin install "regenerate-thumbnails"  --activate

    
    # Install pw_wp_importer plugin
    build_plugin
    $wp_cmd plugin delete pw_wp_importer
    $wp_cmd plugin install /var/www/plugins/pw_wp_importer.zip  --activate

    # Restore the backup
    $wp_cmd pw_importer restore_backup /var/www/backup-prod/ 
    
    
    $wp_cmd db import ./wp-content/amestienda.com.ar.sql
    $wp_cmd search-replace "$PRD_HOST" "$WP_URL" --all-tables

    # Regenerate thumbnails
    $wp_cmd media regenerate --only-missing --yes
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
            # if [ -z "$2" ]; then
            #     echo "Usage: $0 import-data <data-dir>"
            #     exit 1
            # fi
            import #$2
        ;;     
    download-backup-prod)
        download_backup_prod
        ;;   
    regenerate-thumbnails)
        regenerate_thumbnails
        ;;     
    *)
        echo ""
        echo "###############################"
        echo "Usage:" 
        echo " $0 {up [--build]|down|install-cert|install-wp|generate-data|reset-db|import-data|download-backup-prod|regenerate-thumbnails}"

        echo ""
        echo "###############################"
        echo "Basic usage:"
        echo "  ./pw_manager.sh up --build"
        echo "  ./pw_manager.sh install-cert"
        echo "  ./pw_manager.sh install-wp"
        echo "  ./pw_manager.sh import-data"
        echo "" 
        echo "  ./pw_manager.sh download-backup-prod"
        echo "  ./pw_manager.sh regenerate-thumbnails"


        echo ""
        echo "###############################"
        echo "Wordpress:"
        echo "Visit https://${WP_URL} or admin https://${WP_URL}/wp-admin"
        echo "user: ${WP_ADMIN_USER}"
        echo "pass: ${WP_ADMIN_PASS}"
        

        exit 1
esac