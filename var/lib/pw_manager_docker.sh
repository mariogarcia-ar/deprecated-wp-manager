#!/bin/bash
docker_composer="docker compose -f $DOCKER_COMPOSE_YML"

docker_composer_up() {
    echo "Starting services... $1 "
    $docker_composer up $1
}

docker_composer_down() {
    echo "Stoping services... $1"
    $docker_composer down $1
}

docker_prune() {
    docker_composer_down $1

    # TODO: add a user confirmation
    echo "Removing volumes and temp directories..."
    sudo rm -rf $PW_VOLUMES_DIR
    sudo rm -rf $PW_TMP_DIR

    echo "Creating directories ..."
    mkdir -p $PW_VOLUMES_DIR
    mkdir -p $PW_TMP_DIR
}
