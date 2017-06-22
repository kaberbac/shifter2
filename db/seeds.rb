# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


unless UserRole.where(role_name: 'admin').exists?
  admin_user = User.find_by_email("admin@email.com")
  unless admin_user.present?
    admin_user = User.create!(first_name: "iam", last_name: "theboss", email: "admin@email.com", password: "123456")
    puts "-----------------------------------------"
    puts "#{admin_user.full_name} has been created."
    puts "-----------------------------------------"
  end

  if admin_user.present?
    admin_user.user_roles.create!(role_name: Role.get_admin!)
    puts "-----------------------------------------"
    puts "#{admin_user.full_name} has been granted with admin role."
    puts "-----------------------------------------"
  end
end