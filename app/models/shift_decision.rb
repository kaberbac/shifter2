class ShiftDecision < ActiveRecord::Base
  attr_accessible :decision, :shift_id, :user_id

  belongs_to :user
  belongs_to :shift

  scope :ordered, order('created_at desc')

  validates :shift_id, presence: true
  validates :user_id, presence: true
  validates :decision, presence: true, :inclusion => {:in => Shift::STATUSES}

  # will_paginate how many items shown per page
  self.per_page = 10

end
