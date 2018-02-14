#!/bin/bash

export $(cat .env | xargs)

envsubst '${NETWORK_HOST_IP}' < config/configuration.yml.tpl > config/configuration.yml
