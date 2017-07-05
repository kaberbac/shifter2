class AddWorkplaceToShifts < ActiveRecord::Migration
  def change
    add_column :shifts, :workplace_id, :integer
  end
end
