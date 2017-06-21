# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ROLES = %w(admin manager other)

if Role.all.blank?
  ROLES.each do |role|
    Role.create(name: role)
    puts "-----------------------------------------"
    puts "#{role} has been created."
    puts "-----------------------------------------"
  end
end

unless User.find_by_email("admin@email.com").present?
  admin_user = User.create!(first_name: "iam", last_name: "theboss", email: "admin@email.com", password: "123456")
  puts "-----------------------------------------"
  puts "#{admin_user.full_name} has been created."
  puts "-----------------------------------------"
  admin_user.roles.push(Role.first)
  puts "-----------------------------------------"
  puts "#{admin_user.full_name} has been granted with admin role."
  puts "-----------------------------------------"
end