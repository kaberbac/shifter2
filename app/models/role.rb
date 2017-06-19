class Role < ActiveRecord::Base
  attr_accessible :name

  ROLES = %w(admin manager other)
  validates :name, presence: true, uniqueness: true, :inclusion => {:in => ROLES}

end
