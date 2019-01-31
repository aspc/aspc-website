# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "log/jobs.log"

# Jobs specified here will run every time
# the server restarts
every :reboot do
  runner 'MenuImportJob.perform_later'
end

# We import menus data every hour in case any changes were made
every :hour do
  runner 'MenuImportJob.perform_later'
end