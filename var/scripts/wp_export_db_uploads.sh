#!/bin/bash

# fix for php7
cd ~/public_html
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# myphp="/usr/local/lsws/lsphp80/bin/php -d memory_limit=512M -d error_reporting=E_ALL\&~E_WARNING"
# mywp="/usr/local/lsws/lsphp80/bin/php -d memory_limit=512M ~/public_html/wp-cli.phar plugin list  --format=csv"
mywp="/usr/local/lsws/lsphp80/bin/php -d memory_limit=512M /home/amestienda.com.ar/wp-cli.phar "


# This script is used to backup the database and uploads folder of a WordPress site.

# Create a directory to store the backups
cd ~

mkdir -p ~/backup-prod/

# Backup the database
cd ~/public_html

echo "ames.tienda.com.ar" > ~/backup-prod/Readme.txt

wp db export ~/backup-prod/database.sql



$mywp plugin list  --format=csv > ~/backup-prod/plugins.csv
$mywp theme list  --format=csv > ~/backup-prod/themes.csv

$mywp  option list --format=csv > ~/backup-prod/options.csv

$mywp post-type list --format=csv > ~/backup-prod/post-types.csv
$mywp user list --format=csv > ~/backup-prod/users.csv
$mywp user meta list --format=csv > ~/backup-prod/user-meta.csv
$mywp term list --format=csv > ~/backup-prod/terms.csv
$mywp term meta list --format=csv > ~/backup-prod/term-meta.csv
$mywp taxonomy list --format=csv > ~/backup-prod/taxonomies.csv
$mywp taxonomy meta list --format=csv > ~/backup-prod/taxonomy-meta.csv
$mywp role list --format=csv > ~/backup-prod/roles.csv
$mywp capability list --format=csv > ~/backup-prod/capabilities.csv
$mywp sidebar list --format=csv > ~/backup-prod/sidebars.csv
$mywp menu list --format=csv > ~/backup-prod/menus.csv
$mywp menu location list --format=csv > ~/backup-prod/menu-locations.csv
$mywp widget list --format=csv > ~/backup-prod/widgets.csv


# Backup the uploads folder
cd ~/public_html/wp-content/
find ./uploads -type f |  grep  -v -E '\-[[:digit:]]{1,4}x[[:digit:]]{1,4}' | tar -T - -cf - | tar -C  ~/backup-prod/ -xf -

# Compress the backup
cd ~
tar -czf backup-prod.tar.gz -C ~/backup-prod/ .

rm -rf ~/backup-prod/

# Copy the backup to a remote server
LOCAL_DIR="./backup-prod.tar.gz"
REMOTE_DIR="dw_prodtco:~/amestienda.com.ar/"
rsync -avz $LOCAL_DIR $REMOTE_DIR
