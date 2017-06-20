class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :old_password
  has_secure_password

  has_many :shifts
  has_and_belongs_to_many :roles, :uniq=>true

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :first_name, presence: true, length: {in: 2..50}
  validates :last_name, presence: true, length: {minimum: 2, maximum: 50}
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 6 }, unless: lambda { self.persisted? && self.password.nil? }

  def full_name
    first_name.capitalize + ' ' + last_name.upcase
  end


  # check if user have role_name
  def has_role?(role_name)
    # methode 1
    # roles = self.roles.map {|role| role.name}
    # roles.include?(role_name)

    # methode 2
    # self.roles.find do |role|
    #  role.name == role_name
    # end.present?

    # methode 3
    self.roles.where(name: role_name).exists?
  end

  # check if user have role_name in a list of role_names
  def has_role_in_roles_list?(role_name_list)
    # methode 1
    # found_role = role_name_list.find do |role_name|
    #   self.has_role?(role_name)
    # end
    # found_role.present?

    # methode 2
    self.roles.where(name: role_name_list).exists?
  end


  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
