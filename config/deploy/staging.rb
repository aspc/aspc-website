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
set :rails_env, "development"
set :puma_env, fetch(:rails_env, "development")
set :bundle_without, "production"

# Deploy to the staging directory on Peninsula
set :deploy_to, "/srv/www/staging/aspc"

# Specify which branch to stage
if ENV['BRANCH']
  set :branch, ENV['BRANCH']
else
  ask :branch, "Branch to stage"
end