#!/bin/bash

FILE=/aspc/docker/setup_completion_marker

setupYarnPackages(){
    yarn install
}

setupDB() {
    echo "Setting up DB"
    bundle exec rails db:create 
    bundle exec rails db:migrate
    touch $FILE 
}

dbIsSetup() {
    if test -f $FILE; then 
    return 0
    else return 1
    fi
}

setupYarnPackages
dbIsSetup && echo "Database is Already Setup!" || setupDB
echo "Setup Complete"





