class UserRole < ActiveRecord::Base
  attr_accessible :role_name, :user_id

  belongs_to :user

  validates :role_name, inclusion: { in: Role::AVAILABLE_ROLES }
  validates :user, presence: true
end
