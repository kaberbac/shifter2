class UserRole < ActiveRecord::Base
  attr_accessible :role_name, :user_id

  belongs_to :user

  validates :role_name, inclusion: { in: Role::AVAILABLE_ROLES }, :uniqueness => {:scope => :user_id}
  validate :is_last_admin?
  validates :user, presence: true

  def is_last_admin?
    if self.class.where(role_name: Role.get_admin!).count == 1 && self.role_name == Role.get_admin!
      errors.add(:role_name, 'You cant delete the last admin user.')
    end
    errors.blank? #return false, to not destroy the element
  end
end
