#!/bin/bash

cd "$WP_DIR"

# wp site empty --yes	#Empty a site of content (posts and pages)
#Empty the site, including media files
wp site empty --uploads --yes	--allow-root