#!/bin/bash

# Define the wp_cmd and wp_install commands
wp_cmd="docker compose -f $DOCKER_COMPOSE_YML run --rm wp_cmd"
wp_install="docker compose -f $DOCKER_COMPOSE_YML run --rm wp_install"

wp_install() {
    echo "Installing WordPress $WP_VERSION ..."

    cd $BASEDIR
    # Your WordPress installation code here
    $wp_install "$IMPORT_SCRIPTS_DIR/wp_install.sh"
}

# wp_db_reset() {
#     cd $BASEDIR
#     $wp_install "$IMPORT_SCRIPTS_DIR/wp_db_reset.sh"
# }

# wp_import_data() {
#     cd $BASEDIR
#     $wp_install "$IMPORT_SCRIPTS_DIR/wp_import_data.sh"
# }





#     echo "File downloaded to $SFTP_LOCAL_PATH"

#     # unzip the file
#     unzip $SFTP_LOCAL_PATH"/backup-prod.zip" -d $SFTP_LOCAL_PATH

#     echo "File unzipped to $SFTP_LOCAL_PATH"

#     mkdir ./var/backup-prod/ 2>/dev/null
#     mv ./var/tmp/home/amestienda.com.ar/backup-prod/*   ./var/backup-prod/  
# }


# regenerate_thumbnails() {
#     # regenerate-thumbnails/
#     cd $BASEDIR

#     # # Install regenerate-thumbnails plugin
#     # $wp_cmd plugin delete "regenerate-thumbnails"
#     # $wp_cmd plugin install "regenerate-thumbnails"  --activate

    
#     # Install pw_wp_importer plugin
#     build_plugin
#     $wp_cmd plugin delete pw_wp_importer
#     $wp_cmd plugin install /var/www/plugins/pw_wp_importer.zip  --activate

#     # Restore the backup
#     $wp_cmd pw_importer restore_backup /var/www/backup-prod/ 
    
    
#     $wp_cmd db import ./wp-content/amestienda.com.ar.sql
#     $wp_cmd search-replace "$PRD_HOST" "$WP_URL" --all-tables

#     # Regenerate thumbnails
#     $wp_cmd media regenerate --only-missing --yes
# }
