##
# This is the base capistrano deployment configuration
# for deploying this application to the Peninsula.
# Environment-specific configuration may be found in
# config/deploy/production.rb, config/deploy/staging.rb

# Config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

# The repo we are deploying. This should be the same
# across production/staging configs.
set :application, "aspc"
set :repo_url, "https://github.com/aspc/aspc-website.git"

# SSH Authentication
ssh_credentials = YAML.load(`rails credentials:show`).dig("capistrano", "ssh")
if ssh_credentials["user"] && ssh_credentials["password"]
    set :user, ssh_credentials["user"]
    set :password, ssh_credentials["password"]
else
    ask :user, "Username for peninsula.pomona.edu"
    ask :password, "Password for peninsula.pomona.edu", echo: false
end

# Git permissions
set :git_wrapper_path, lambda {
    # Try to avoid permissions issues when multiple users deploy the same app
    # by using different file names in the same dir for each deployer and stage.
    suffix = %i(application stage user).map { |key| fetch(key).to_s }.join("-")

    "#{fetch(:tmp_dir)}/git-ssh-#{suffix}.sh"
}

# Set default rails environment to production (may be overridden in production/staging configs)
set :rails_env, :production

# Linked files are shared between deploys
append :linked_files, "config/master.key" # Share master.key for encrypted credentials
append :linked_files, "puma.rb" # Server configuration
append :linked_dirs, "tmp/pids" # Runfiles
append :linked_dirs, "tmp/sockets" # Runfiles
append :linked_dirs, "log" # Log files
append :linked_dirs, "storage" # Active Storage files
append :linked_dirs, "public/uploads" # Froala public image uploads

# Keep the latest 3 deployments on the server at all times
set :keep_releases, 3

# Namespace the crontab to the deploy environment
set :whenever_path, Proc.new { release_path }
set :whenever_environment, Proc.new { fetch(:stage) }
set :whenever_identifier, Proc.new { "#{fetch(:application)}_#{fetch(:stage)}" }
