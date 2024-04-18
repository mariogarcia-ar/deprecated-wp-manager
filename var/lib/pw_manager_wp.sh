#!/bin/bash

# Define the wp_cmd and wp_install commands
wp_cmd="docker compose -f $DOCKER_COMPOSE_YML run --rm wp_cmd"
wp_install="docker compose -f $DOCKER_COMPOSE_YML run --rm wp_install"

mount_scripts() {
   sudo cp -r $PW_SERVICES_DIR"/wp/scripts/" $PW_SHARED_DIR
   echo "Scripts mounted in $PW_SHARED_DIR/scripts"
}

mount_data() {
   sudo cp -r $PW_DATA_DIR $PW_SHARED_DIR
   echo "Data mounted in $PW_SHARED_DIR/data"
}

wp_install() {
    echo "Installing WordPress $WP_VERSION ..."
    mount_scripts

    cd $BASEDIR
    # Your WordPress installation code here
    $wp_install "$PW_CONTAINER_SCRIPTS_DIR/wp_install.sh"
}

# wp_db_reset() {
#     cd $BASEDIR
#     $wp_install "$PW_CONTAINER_SCRIPTS_DIR/wp_db_reset.sh"
# }

wp_import_local_data() {
    echo "Importing data ..."
    mount_scripts
    mount_data

    cd $BASEDIR
    wp_package_plugins

    $wp_install "$PW_CONTAINER_SCRIPTS_DIR/wp_import_local_data.sh"
}

wp_restore_backup() {
    echo "Restoring backup ..."
    mount_scripts
    mount_data

    cd $BASEDIR
    wp_package_plugins

    $wp_install "$PW_CONTAINER_SCRIPTS_DIR/wp_restore_backup.sh"
}


wp_site_empty() {
    echo "Emptying site ..."
    mount_scripts
    mount_data

    cd $BASEDIR
    wp_package_plugins

    $wp_install "$PW_CONTAINER_SCRIPTS_DIR/wp_site_empty.sh"
}

wp_restore_plugins() {
    echo "Restoring plugins ..."
    mount_scripts
    mount_data

    cd $BASEDIR
    wp_package_plugins

    $wp_install "$PW_CONTAINER_SCRIPTS_DIR/wp_restore_plugins.sh"
}

wp_restore_themes() {
    echo "Restoring themes ..."
    mount_scripts
    mount_data

    cd $BASEDIR
    wp_package_plugins

    $wp_install "$PW_CONTAINER_SCRIPTS_DIR/wp_restore_themes.sh"
}