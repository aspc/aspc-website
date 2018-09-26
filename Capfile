# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Load the SCM plugin appropriate to your project:
#
# require "capistrano/scm/hg"
# install_plugin Capistrano::SCM::Hg
# or
# require "capistrano/scm/svn"
# install_plugin Capistrano::SCM::Svn
# or
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in your Gemfile

# RVM compatibility
require "capistrano/rvm"

# Load Rails plugins
require "capistrano/rails"
require "capistrano/puma"
require "capistrano/yarn"

install_plugin Capistrano::Puma  # Default puma tasks

# Execute rake tasks remotely
require "capistrano/rake"

# Schedule Active Jobs with Whenever
require "whenever/capistrano"
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
