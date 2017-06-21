class UserRole < ActiveRecord::Base
  attr_accessible :role_name, :user_id

  belongs_to :user

  validates :role_name, inclusion: { in: Role::AVAILABLE_ROLES }, :uniqueness => {:scope => :user_id}
  validates :user, presence: true
end
