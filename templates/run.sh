#!/bin/sh
set -e

test $DB_HOST || DB_HOST=$(cat /run/secrets/db_keys/db_host | tr -d ' \n')
export DB_HOST

test $DB_USERNAME || DB_USERNAME=$(cat /run/secrets/db_keys/db_username | tr -d ' \n')
export DB_USERNAME

test $DB_PASSWORD || DB_PASSWORD=$(cat /run/secrets/db_keys/db_password | tr -d ' \n')
export DB_PASSWORD

test $ENCRYPT_SECRET_KEY || ENCRYPT_SECRET_KEY=$(cat /run/secrets/db_keys/encrypt_secret_key | tr -d ' \n')
export ENCRYPT_SECRET_KEY

test $JWT_SECRET_KEY || JWT_SECRET_KEY=$(cat /run/secrets/db_keys/jwt_secret_key | tr -d ' \n')
export JWT_SECRET_KEY

java -jar service.jar