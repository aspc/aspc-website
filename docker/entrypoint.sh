#!/bin/bash

set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /myapp/tmp/pids/server.pid

# Run the setup Script
echo "Running Setup"
sh docker/setup.sh 

# Cleanup stale server.pid and logs
rm -f /aspc/tmp/pids/server.pid
touch /aspc/log/development.log /aspc/log/capistrano.log
chmod 777 /aspc/log/*.log

exec "$@"