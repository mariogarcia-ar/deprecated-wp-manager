cd "$WP_DIR"

wp plugin install fakerpress --activate  --allow-root
wp fakerpress generate posts --count=50  --allow-root
wp fakerpress generate posts --count=10 --type=page  --allow-root
wp fakerpress generate comments --count=100  --allow-root
# wp plugin deactivate fakerpress  --allow-root
# wp plugin delete fakerpress  --allow-root
