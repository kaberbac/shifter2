class ShiftDecision < ActiveRecord::Base
  attr_accessible :decision, :shift_id, :user_id

  belongs_to :user
  belongs_to :shift

  scope :ordered, order('created_at desc')
  scope :history_status, lambda { |shiftid| where(shift_id: shiftid) }

  validates :shift_id, presence: true
  validates :user_id, presence: true
  validates :decision, presence: true, :inclusion => {:in => Shift::STATUSES}

end
