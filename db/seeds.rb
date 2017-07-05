# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).



unless UserRole.any_admin_active?

  admin_user = User.find_by_email("admin@email.com")
  unless admin_user.present?
    admin_user = User.create!(first_name: "iam", last_name: "theboss", email: "admin@email.com", password: "123456", state: "active")
    puts "-----------------------------------------"
    puts "#{admin_user.full_name} has been created."
    puts "-----------------------------------------"
  end

  if admin_user.present?
    if !admin_user.is_admin?
      admin_user.user_roles.create!(role_name: Role.get_admin!)
      puts "-----------------------------------------"
      puts "#{admin_user.full_name} has been granted with admin role."
      puts "-----------------------------------------"
    end
    if admin_user.state == 'inactive'
      admin_user.update_attributes(state: 'active')
      puts "--------------------------------------------------"
      puts "#{admin_user.full_name} account has been activated"
      puts "--------------------------------------------------"
    end
  end
end

