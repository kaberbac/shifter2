class Approval < ActiveRecord::Base
  attr_accessible :decision, :shift_id, :user_id

  DECISIONS = %w(admin manager other)

  validates :shift_id, presence: true
  validates :user_id, presence: true
  validates :decision, presence: true, uniqueness: true, :inclusion => {:in => DECISIONS}

end
