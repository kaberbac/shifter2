class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.integer :user_id
      t.string :role_name
    end
  end
end
