# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR"/../../../../../

# create zip
./var/docker/services/wp/plugins/pw_wp_importer/build.sh

#Install 
docker compose run --rm wp_cmd plugin delete pw_wp_importer
docker compose run --rm wp_cmd plugin install /var/www/plugins/pw_wp_importer.zip  --activate

# Test

# Taxonomies, categories and tags
docker compose run --rm wp_cmd pw_importer category  "./wp-content/plugins/pw_wp_importer/data/category.csv"
docker compose run --rm wp_cmd pw_importer tag  "./wp-content/plugins/pw_wp_importer/data/tag.csv"
docker compose run --rm wp_cmd pw_importer taxonomy  "./wp-content/plugins/pw_wp_importer/data/taxonomy.csv" category

# Users
docker compose run --rm wp_cmd pw_importer user  "./wp-content/plugins/pw_wp_importer/data/user.csv"

# Attachment
docker compose run --rm wp_cmd pw_importer attachment  "./wp-content/plugins/pw_wp_importer/data/attachment.csv"

# Post
docker compose run --rm wp_cmd pw_importer post  "./wp-content/plugins/pw_wp_importer/data/post.csv"
docker compose run --rm wp_cmd pw_importer post_meta  "./wp-content/plugins/pw_wp_importer/data/post_meta.csv"
docker compose run --rm wp_cmd pw_importer thumbnail  "./wp-content/plugins/pw_wp_importer/data/thumbnail.csv"

