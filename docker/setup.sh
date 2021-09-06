#!/bin/bash

FILE=/aspc/docker/setup_completion_marker

setupYarnPackages(){
    yarn install
}

setupDB() {
    echo "Setting up DB"
    bundle exec db:create 
    bundle exec db:migrate
}

dbIsSetup() {
    if test -f $FILE; then 
    return 0
    else return 1 
}





