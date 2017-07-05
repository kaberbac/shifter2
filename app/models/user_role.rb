class UserRole < ActiveRecord::Base
  attr_accessible :role_name, :user_id, :workplace_id

  # constants

  # relations
  belongs_to :user
  belongs_to :workplace

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


  def self.count_admin_active?
    counter = 0
    my_user_role = UserRole.where(role_name: Role.get_admin!)
    my_user_role.pluck(:user_id).each do |userid|
      if User.find(userid).state == 'active'
        counter +=1
      end
    end
    return counter
  end

  def self.any_admin_active?
    self.count_admin_active? > 0
  end


end
