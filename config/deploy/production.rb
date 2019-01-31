# The server we deploy to
# ======================
server "peninsula.pomona.edu", user: fetch(:user), password: fetch(:password), roles: %w{app db web}

# Configuration
# =============
# You can set any configuration variable like in config/deploy.rb
# These variables are then only loaded and set in this stage.
# For available Capistrano configuration variables see the documentation page.
# http://capistranorb.com/documentation/getting-started/configuration/

# Ensure the rails and puma environments match up
set :rails_env, "production"
set :puma_env, "production"
set :bundle_without, "development"

# Deploy to the staging directory on Peninsula
set :deploy_to, "/srv/www/main/aspc"

# Set Puma Application Server Config
set :puma_daemonize, false

set :puma_access_log, "#{shared_path}/log/puma_access.log"
set :puma_error_log, "#{shared_path}/log/puma_error.log"

set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"

set :puma_init_active_record, true

# Install yarn modules
set :yarn_target_path, -> { release_path }

# Specify which branch to stage
set :branch, "master"

namespace :deploy do
  after :finishing, 'remote:update_crontab'
end