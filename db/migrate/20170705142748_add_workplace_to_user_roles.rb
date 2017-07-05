class AddWorkplaceToUserRoles < ActiveRecord::Migration
  def change
    add_column :user_roles, :workplace_id, :integer
  end
end
