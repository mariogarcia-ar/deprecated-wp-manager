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