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

# Linked files are shared between deploys
append :linked_files, "config/master.key" # Share master.key for encrypted credentials
append :linked_files, "puma.rb" # Server configuration
append :linked_dirs, "tmp/pids" # Runfiles
append :linked_dirs, "tmp/sockets" # Runfiles
append :linked_dirs, "log" # Log files
append :linked_dirs, "storage" # Active Storage files

# Keep the latest 3 deployments on the server at all times
set :keep_releases, 3