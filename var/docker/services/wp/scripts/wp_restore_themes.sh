#!/bin/bash

cd "$WP_DIR"

#Install 
wp plugin delete pw_wp_importer  --allow-root
wp plugin install "${PW_CONTAINER_SHARED_DIR}/wp/plugins/pw_wp_importer.zip"  --activate  --allow-root


# Restore the backup
wp pw_importer restore_themes "$PW_CONTAINER_BACKUP_PROD_DIR"   --allow-root
