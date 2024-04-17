#!/bin/bash

PW_VAR_DIR=$BASEDIR"/var/"
PW_LIB_DIR=$PW_VAR_DIR"/lib/"

# Utils
PW_SSH_DIR=$PW_VAR_DIR"/.ssh/"
PW_TMP_DIR=$PW_VAR_DIR"/tmp/"

# Data, migrations
PW_DATA_DIR=$PW_VAR_DIR"/data/"

# Docker
PW_SERVICES_DIR=$PW_VAR_DIR"/docker/services/"
PW_VOLUMES_DIR=$PW_VAR_DIR"/docker/volumes/"

DOCKER_COMPOSE_YML=$BASEDIR/docker-compose.yml


