# Run
```bash
# chmod +x build.sh

# create zip
./var/docker/services/wp/plugins/pw_wp_importer/build.sh

#Install 
docker compose run --rm wp_cmd plugin delete pw_wp_importer
docker compose run --rm wp_cmd plugin install /var/www/plugins/pw_wp_importer.zip  --activate

# Test
docker compose run --rm wp_cmd pw_importer category  "./wp-content/plugins/pw_wp_importer/data/category.csv"
docker compose run --rm wp_cmd pw_importer tag  "./wp-content/plugins/pw_wp_importer/data/tag.csv"
docker compose run --rm wp_cmd pw_importer taxonomy  "./wp-content/plugins/pw_wp_importer/data/taxonomy.csv" category

```


