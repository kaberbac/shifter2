# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


unless Workplace.find_by_name('no_workplace').present?
  Workplace.create!(name: 'no_workplace', address: 'unknown')
  puts "-----------------------------------------"
  puts "no_workplace workplace has been created. "
  puts "-----------------------------------------"
end

if Workplace.find_by_name('no_workplace').present?
  Shift.all.each do |shift|
    if shift.workplace_id.nil?
      shift.update_attributes(workplace_id: Workplace.find_by_name('no_workplace').id)
      puts "------------------------------------------------------------------"
      puts "shift with id=#{shift.id} workplace has been set to no_workplace. "
      puts "------------------------------------------------------------------"
    end
  end
end



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

