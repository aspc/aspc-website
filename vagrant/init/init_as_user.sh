#!/usr/bin/env bash
cd /home/vagrant

# Up the ulimit (intended for watchmedo, may not be necessary)
if grep -Fxq "ulimit -n 2048" /home/vagrant/.profile
then
    echo "Already have ulimit line in ~/.profile"
else
    echo "Upping ulimit to 2048 in ~/.profile"
    echo "ulimit -n 2048" >> /home/vagrant/.profile
    ulimit -n 2048
fi


# pre-populate ssh known_hosts with the Peninsula pubkey
mkdir -p /home/vagrant/.ssh
if [ ! -f /home/vagrant/.ssh/known_hosts ]; then
    cp /vagrant/vagrant/init/known_hosts /home/vagrant/.ssh/known_hosts
fi

# Create folder for Puma socket and pidfile
mkdir -p /home/vagrant/run

# create tables
cd /vagrant
source /home/vagrant/.rvm/scripts/rvm
rake db:create

# copy static files
# python /vagrant/manage.py collectstatic --noinput

# load fixtures (order is important)
# python /vagrant/manage.py loaddata /vagrant/fixtures/sites.json
# python /vagrant/manage.py loaddata /vagrant/fixtures/users.json
# python /vagrant/manage.py loaddata /vagrant/fixtures/appointments.json
# python /vagrant/manage.py loaddata /vagrant/fixtures/folio.json
# python /vagrant/manage.py loaddata /vagrant/fixtures/blog.json
# python /vagrant/manage.py loaddata /vagrant/fixtures/eatshop.json
# python /vagrant/manage.py loaddata /vagrant/fixtures/sagelist.json
# python /vagrant/manage.py loaddata /vagrant/fixtures/mhdata.json

# load housing data
# python /vagrant/manage.py load_dorms
# python /vagrant/manage.py load_maps
# python /vagrant/manage.py load_dorm_rooms
# python /vagrant/manage.py loaddata /vagrant/fixtures/housing.json

# generate fake data for certain apps
# python /vagrant/manage.py fakeevents
# python /vagrant/manage.py scrape_twitter
# python /vagrant/manage.py load_menus
