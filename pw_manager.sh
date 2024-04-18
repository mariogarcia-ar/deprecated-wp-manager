#!/bin/bash

# TODO: CORREO ELECTORNICOS CAPTURAR
# TODO: WOO BASE CON PLUGINS Y THEMES
# TODO: WP CON DIVI Y PLUGINS

# chmod +x pw_manager.sh
BASEDIR=$(dirname "$(realpath "$0")")

# loac the config file
source $BASEDIR"/var/lib/pw_init.sh" #2>/dev/null


# Check the command line argument
case $1 in
    # Docker Stack
    up)
        docker_composer_up $2
        ;;
    down)
        docker_composer_down $2
        ;;        
    prune)
        docker_prune $2
        ;;        

    # Lamp 
    emit-cert)
        lamp_emit_cert
        ;;
    download-backup)
        lamp_download_backup
        ;;
    download-plugins)
        lamp_download_plugins
        ;;
    download-themes)
        lamp_download_themes
        ;;
                
    # Wordpress
    wp-install)
        wp_install $2
        ;;
    wp-import-local-data)
        wp_import_local_data $2
        ;;
    wp-site-empty)
        wp_site_empty $2
        ;;
    wp-restore-backup)
        wp_restore_backup $2
        ;;
    wp-restore-plugins)
        wp_restore_plugins $2
        ;;
    wp-restore-themes)
        wp_restore_themes $2
        ;;
    # Help
    *)
        echo "Usage: $0 <ommand>"
        
        echo ""
        echo "Docker Stack:"
        echo "  $0 up [--build|-d]"
        echo "  $0 down [--volumen]"
        echo "  $0 prune"
        
        echo ""
        echo "Lamp:"
        echo "  $0 emit-cert (mkcert required)"    
        echo "  $0 download-backup"    
        echo "  $0 download-plugins                 # TODO"    
        echo "  $0 download-themes                  # TODO"    
        
        echo ""
        echo "Wordpress:"
        echo "  $0 wp-install"        
        echo "  $0 wp-import-local-data"        
        echo "  $0 wp-import-local-plugins          # TODO"        
        echo "  $0 wp-import-local-themes           # TODO"        
        echo "  $0 wp-restore-backup                #(depends on download-backup) restore db, uploads and attachments"
        echo "  $0 wp-restore-plugins               #(depends on wp-restore-backup)"
        echo "  $0 wp-restore-themes                #(depends on wp-restore-backup)"
        echo "  $0 wp-site-empty                    #(todo: plugin / theme)"
        echo ""
        echo "Visit https://${WP_URL} or admin https://${WP_URL}/wp-admin"
        echo "user: ${WP_ADMIN_USER}"
        echo "pass: ${WP_ADMIN_PASS}"        
esac
