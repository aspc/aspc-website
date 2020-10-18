#!/usr/bin/env bash
set -e

function info {
    echo "$(tput bold)$(tput setaf 3)[*****] $1$(tput sgr0)"
}

function err {
    echo "$(tput bold)$(tput setaf 1)[!!!!!] $1$(tput sgr0)"
}

export DEBIAN_FRONTEND=noninteractive
update-locale LANG=en_US.UTF-8
if [ -f /root/apt.updated ]; then
    filemtime=`stat -c %Y /root/apt.updated`
    currtime=`date +%s`
    diff=$(( (currtime - filemtime) / 86400 ))
    if [ $diff -gt 7 ]; then
        info "Last update more than a week ago, running apt-get update"
        apt-get -y update
        touch /root/apt.updated
    else
        info "Recently ran apt-get update ($diff days ago), skipping"
    fi
else
    info "First boot, running apt-get update"
    apt-get -y update
    touch /root/apt.updated
fi

# Yarn / Node apt-get repositories
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Dependencies for ASPC Main Site
apt-get update
apt-get -y install build-essential git nginx postgresql libpq-dev python-dev \
    libsasl2-dev libssl-dev libffi-dev gnupg2 nodejs \
    curl libjpeg-dev libxml2-dev libxslt-dev nodejs yarn google-chrome-stable


# Set up PostgreSQL
info "Setting up PostgreSQL configuration..."
/etc/init.d/postgresql stop
cat /vagrant/vagrant/db/pg_hba_prepend.conf /etc/postgresql/9.5/main/pg_hba.conf > /tmp/pg_hba.conf
mv /tmp/pg_hba.conf /etc/postgresql/9.5/main/pg_hba.conf
/etc/init.d/postgresql start

info "Creating user 'main' in PostgreSQL (if it doesn't exist)"
sudo -u postgres psql -f /vagrant/vagrant/db/setup_postgres.sql

# if [ $(sudo -u postgres psql -l | grep main_django | wc -l) -eq 0 ]; then
#    info "Creating a 'main_django' database..."
    # Can't get Ubuntu 12.04 to install Postgres with a sensible default locale
    # so we a) create the db from template0 and b) specify en_US.utf8
#    sudo -u postgres psql -c "CREATE DATABASE aspc_rails  WITH ENCODING = 'UTF-8' LC_CTYPE = 'en_US.UTF-8' LC_COLLATE = 'en_US.UTF-8' OWNER main TEMPLATE template0" && info "Done!"
# else
#    info "Database 'aspc_rails' already exists"
# fi

# Install project dependencies
cd /vagrant # Switch to project directories
source /home/vagrant/.rvm/scripts/rvm # Setup rvm environment
bundle install # Install Gemfile dependencies

# Some steps should be performed as the regular vagrant user
sudo -u vagrant bash /vagrant/vagrant/init/init_as_user.sh