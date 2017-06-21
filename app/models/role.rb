class Role < ActiveRecord::Base
  attr_accessible :name
  before_destroy :destroy_protection

  ROLES = %w(admin manager other)
  validates :name, presence: true, uniqueness: true, :inclusion => {:in => ROLES}

  def destroy_protection
    raise "You can not destroy a role, the application needs it."
  end
end
