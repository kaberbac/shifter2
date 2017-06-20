class CreateApprovals < ActiveRecord::Migration
  def change
    create_table :approvals do |t|
      t.integer :shift_id
      t.integer :user_id
      t.string :decision

      t.timestamps
    end
  end
end
