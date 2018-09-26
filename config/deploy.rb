##
# This is the base capistrano deployment configuration
# for deploying this application to the Peninsula.
# Environment-specific configuration may be found in
# config/deploy/production.rb, config/deploy/staging.rb

# Config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

# The repo we are deploying. This should be the same
# across production/staging configs.
set :application, "aspc"
set :repo_url, "https://github.com/aspc/aspc-website.git"

# SSH Authentication
ask :user, "Username for peninsula.pomona.edu"
ask :password, "Password for peninsula.pomona.edu", echo: false

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Set default rails environment to production (may be overridden in production/staging configs)
set :rails_env, :production

# Set the location to deploy to (may be overridden in production/staging configs)
set :deploy_to, "/srv/www/staging/aspc"

# Set Puma Application Server Config
set :puma_daemonize, false

set :puma_access_log, "#{shared_path}/log/puma_access.log"
set :puma_error_log, "#{shared_path}/log/puma_error.log"

set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"

set :puma_init_active_record, true

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Linked files are shared between deploys
append :linked_files, "config/master.key" # Share master.key for encrypted credentials
append :linked_files, "puma.rb" # Server configuration
append :linked_dirs, "tmp/pids" # Runfiles
append :linked_dirs, "tmp/sockets" # Runfiles
append :linked_dirs, "log" # Log files
append :linked_dirs, "storage" # Active Storage files

# Install yarn modules
set :yarn_target_path, -> { release_path }

# Set the environment variables on the host machine
set :default_env, {
    # The production database is protected by a password,
    # so make sure to specify it when deploying, otherwise
    # db creation/migration will fail on production
    #
    # If you don't know it, it can be found in the private aspc docs repo,
    # to which ASPC developers should have access
    'ASPC_DATABASE_PASSWORD': ENV["ASPC_DATABASE_PASSWORD"] || "",
}

# Keep the latest 3 deployments on the server at all times
set :keep_releases, 3