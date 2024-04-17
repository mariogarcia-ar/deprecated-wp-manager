#!/bin/bash

cd "$WP_DIR"

#Install 
wp plugin delete pw_wp_importer  --allow-root
wp plugin install "${PW_CONTAINER_SHARED_DIR}/wp/plugins/pw_wp_importer.zip"  --activate  --allow-root

# Test

# Taxonomies, categories and tags
wp pw_importer category  "${PW_CONTAINER_DATA_DIR}/category.csv"  --allow-root
wp pw_importer tag  "${PW_CONTAINER_DATA_DIR}/tag.csv"  --allow-root
wp pw_importer taxonomy  "${PW_CONTAINER_DATA_DIR}/taxonomy.csv" category  --allow-root

# Users
wp pw_importer user  "${PW_CONTAINER_DATA_DIR}/user.csv"  --allow-root

# Attachment
wp pw_importer attachment  "${PW_CONTAINER_DATA_DIR}/attachment.csv"  --allow-root

# Post
wp pw_importer post  "${PW_CONTAINER_DATA_DIR}/post.csv"  --allow-root
wp pw_importer post_meta  "${PW_CONTAINER_DATA_DIR}/post_meta.csv"  --allow-root
wp pw_importer thumbnail  "${PW_CONTAINER_DATA_DIR}/thumbnail.csv"  --allow-root

