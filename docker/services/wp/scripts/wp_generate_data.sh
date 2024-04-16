#!/bin/bash

cd "$WP_DIR"

 

# Generate posts
for post_type in page post; 
do
    wp post generate --count=100 --post_type=$post_type --allow-root
    # curl -N https://loripsum.net/api/5 | wp post generate --post_content --count=10 --allow-root

done

# Generate users
wp user generate --count=50 --allow-root
