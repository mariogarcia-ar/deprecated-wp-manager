#!/bin/bash

# chmod +x build.sh
# ./docker/services/wp/plugins/pw_wp_importer/build.sh

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR"/.. 
rm pw_wp_importer.zip
zip -r pw_wp_importer.zip pw_wp_importer