# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, '/home/deploy/apps/venuevortex/cron/cron.log'
#
every 10.minutes do
  # command "/usr/bin/some_great_command"
  # runner "MyModel.some_method"
  rake 'new_comment_notifications'
  rake 'capture_charges'
end

every 1.day, at: '12:30 am' do
  rake 'update_packages'
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
