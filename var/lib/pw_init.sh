#!/bin/bash

# load the .env file
source $BASEDIR"/.env" 2>/dev/null

# load the config file
source $BASEDIR"/var/lib/pw_config.sh" #2>/dev/null


# include libraries
source $PW_LIB_DIR"/pw_manager_utils.sh"
source $PW_LIB_DIR"/pw_manager_docker.sh"
source $PW_LIB_DIR"/pw_manager_lamp.sh"
source $PW_LIB_DIR"/pw_manager_wp.sh"
# source $PW_LIB_DIR"/pw_manager_wp_plugins.sh"



