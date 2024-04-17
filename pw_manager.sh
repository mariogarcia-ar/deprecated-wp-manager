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

    # Help
    *)
        echo "Usage: $0 <ommand>"
        
        echo ""
        echo "Docker Stack:"
        echo "  ./pw_manager.sh up [--build|-d]"
        echo "  ./pw_manager.sh down [--volumen]"
esac
