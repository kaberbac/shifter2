class UserRole < ActiveRecord::Base
  attr_accessible :role_name, :user_id

  # constants

  # relations
  belongs_to :user

  # scopes

  # validations
  validates :role_name, inclusion: { in: Role::AVAILABLE_ROLES }, :uniqueness => {:scope => :user_id}
  validate :is_last_admin?, on: :destroy
  validates :user, presence: true

  # callbacks



  def is_last_admin?
    if self.class.where(role_name: Role.get_admin!).count == 1 && self.role_name == Role.get_admin!
      errors.add(:role_name, 'You cant delete the last admin user.')
    end
    errors.blank? #return false, to not destroy the element
  end
end
