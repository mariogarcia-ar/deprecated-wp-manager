# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR"/../../../../../

# create zip
./docker/services/wp/plugins/pw_wp_importer/build.sh

#Install 
docker compose run --rm wp_cmd plugin delete pw_wp_importer
docker compose run --rm wp_cmd plugin install /var/www/plugins/pw_wp_importer.zip  --activate

# Test
docker compose run --rm wp_cmd pw_importer category  "./wp-content/plugins/pw_wp_importer/data/category.csv"
docker compose run --rm wp_cmd pw_importer tag  "./wp-content/plugins/pw_wp_importer/data/tag.csv"
docker compose run --rm wp_cmd pw_importer taxonomy  "./wp-content/plugins/pw_wp_importer/data/taxonomy.csv" category

docker compose run --rm wp_cmd pw_importer user  "./wp-content/plugins/pw_wp_importer/data/user.csv"

