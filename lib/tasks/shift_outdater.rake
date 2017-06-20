# this task should be called periodically every day to outdate Shifts with pending status in the past
# rake shifts:do_outdate
# pattern:
# rake <namespace>:<task_name>

namespace :shifts do
#         ^^^^^^^ namespace
  desc 'Will set statuts = outdated for Shift with pending status with day_work in past'
  task do_outdate: :environment do
    #  ^^^^^^^^^^ task_name
    ShiftOutdater.execute
  end
end