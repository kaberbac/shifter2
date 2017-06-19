class RolesUser < ActiveRecord::Base
  attr_accessible :role_id, :user_id

  validates :role_id, presence: true
  validates :user_id, presence: true
end
