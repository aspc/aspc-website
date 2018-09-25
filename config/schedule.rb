# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "log/jobs.log"

# Jobs specified here will run every time
# the server restarts
every :reboot do
end

# We import menus and course data every day
every :day, at: '3:00 am' do
  runner 'MenuImportJob.perform_later'
end

every :day, at: '4:00 am' do
  runner 'CourseImportJob.perform_later'
end