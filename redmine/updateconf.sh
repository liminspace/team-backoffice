#!/bin/bash

export $(cat .env | xargs)
envsubst '${NETWORK_HOST_IP}' < config/configuration.yml.tpl > config/configuration.yml

if [ ! -f config/initializers/secret_token.rb ]; then
    SECRET_KEY=$(LC_ALL=C; dd if=/dev/urandom bs=1M count=4 2> /dev/null | tr -dc 'a-zA-Z0-9' 2> /dev/null | head -c 96)
    export SECRET_KEY
    envsubst '${SECRET_KEY}' < config/initializers/secret_token.rb.tpl > config/initializers/secret_token.rb
fi
