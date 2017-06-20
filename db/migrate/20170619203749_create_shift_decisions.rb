class CreateShiftDecisions < ActiveRecord::Migration
  def change
    create_table :shift_decisions do |t|
      t.integer :shift_id
      t.integer :user_id
      t.string :decision

      t.timestamps
    end
  end
end
