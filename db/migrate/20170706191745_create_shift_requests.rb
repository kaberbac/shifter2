class CreateShiftRequests < ActiveRecord::Migration
  def change
    create_table :shift_requests do |t|
      t.date :day_work
      t.integer :user_id
      t.integer :manager_id
      t.integer :workplace_id
      t.string :status, default: 'requested'

      t.timestamps
    end
  end
end
