#!/bin/bash

# Change to the WordPress directory
cd "$WP_DIR"

# Purge the database
wp db reset --yes --allow-root