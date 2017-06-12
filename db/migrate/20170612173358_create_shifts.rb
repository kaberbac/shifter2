class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.date :day_work
      t.integer :user_id

      t.timestamps
    end
  end
end
