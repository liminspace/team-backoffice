#!/bin/bash

cat_tpl() {
    echo "cat << EOT"
    cat "$1"
    echo "EOT"
}

source ./.env

cat_tpl config/configuration.yml.tpl | bash > config/configuration.yml
