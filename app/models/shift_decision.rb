class ShiftDecision < ActiveRecord::Base

  # will_paginate how many items shown per page
  self.per_page = 10

  attr_accessible :decision, :shift_id, :user_id

  # constants
  # relations
  belongs_to :user
  belongs_to :shift

  # scopes
  scope :ordered, order('created_at desc')

  # validations
  validates :shift_id, presence: true
  validates :user_id, presence: true
  validates :decision, presence: true, :inclusion => {:in => Shift::STATUSES}

  # callbacks

end
