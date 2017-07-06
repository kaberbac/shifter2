class ShiftRequest < ActiveRecord::Base
  # will_paginate how many items shown per page
  self.per_page = 10
  attr_accessible :day_work, :manager_id, :user_id, :workplace_id, :status

  # constants
  # relations
  belongs_to :user
  belongs_to :workplace

  # scopes
  scope :ordered, order('created_at desc')

  # validations
  validates :day_work, presence: true
  validates :manager_id, presence: true
  validates :user_id, presence: true
  validates :workplace_id, presence: true
  validates :status, presence: true

  # callbacks
end
