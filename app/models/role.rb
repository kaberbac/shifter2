# plain old ruby object (PORO)
# this object behaves like a model, but is not stored in the database
# define static data: list of available roles for users

class Role
  AVAILABLE_ROLES = %w( admin manager )

  def self.get_admin!
    self.get_some_role!('admin')
  end

  def self.get_manager!
    self.get_some_role!('manager')
  end

  def self.all
    AVAILABLE_ROLES
  end

  private

  def self.get_some_role!(role_name_to_find)
    AVAILABLE_ROLES.find { |role_name| role_name == role_name_to_find } || (raise "Role #{role_name_to_find} not found!")
  end
end