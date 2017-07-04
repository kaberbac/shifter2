class Workplace < ActiveRecord::Base

  # will_paginate how many items shown per page
  self.per_page = 10

  attr_accessible :address, :name

  # constants

  # relations
  # scopes
  # validations
  # callbacks
end
