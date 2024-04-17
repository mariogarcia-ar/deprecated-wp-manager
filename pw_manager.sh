#!/bin/bash

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
        echo "  $0 emit-cert"        
esac
