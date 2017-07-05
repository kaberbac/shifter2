class Workplace < ActiveRecord::Base

  # will_paginate how many items shown per page
  self.per_page = 10

  attr_accessible :address, :name

  # constants

  # relations
  has_many :shifts, dependent: :restrict
  has_many :user_roles, dependent: :restrict
  # scopes
  # validations
  validates :name, presence: true, uniqueness: true
  validates :address, presence: true
  # callbacks
end
