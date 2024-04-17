#!/bin/bash

cd "$WP_DIR"

#Install 
wp plugin delete pw_wp_importer  --allow-root
wp plugin install "${PW_CONTAINER_SHARED_DIR}/wp/plugins/pw_wp_importer.zip"  --activate  --allow-root


# Restore the backup
wp pw_importer restore_backup "$PW_CONTAINER_BACKUP_PROD_DIR"   --allow-root

# Restpre the database
wp db import "$PW_CONTAINER_BACKUP_PROD_DIR/database.sql"  --allow-root
wp search-replace "$PRD_HOST" "$WP_URL" --all-tables  --allow-root

# Regenerate thumbnails
wp media regenerate --only-missing --yes  --allow-root