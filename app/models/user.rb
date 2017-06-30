class User < ActiveRecord::Base

  # will_paginate how many items shown per page
  self.per_page = 10

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :old_password, :state
  has_secure_password

  # constants
  STATES = %w(inactive active)

  # relations
  has_many :shifts, dependent: :restrict
  has_many :shift_decisions, dependent: :restrict
  has_many :user_roles, dependent: :destroy

  # scopes

  # validations
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :first_name, presence: true, length: {in: 2..50}
  validates :last_name, presence: true, length: {minimum: 2, maximum: 50}
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 6 }, unless: lambda { self.persisted? && self.password.nil? }
  validates :state, presence: true, :inclusion=> { :in => STATES }

  # callbacks
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  before_validation(on: :create) do
    self.state ||= 'inactive'
  end

  def full_name
    first_name.capitalize + ' ' + last_name.upcase
  end

  def is_active?
    self.state == 'active'
  end

  def is_inactive?
    self.state == 'inactive'
  end

  def is_admin?
    self.has_role?(Role.get_admin!)
  end

  def is_manager?
    self.has_role?(Role.get_manager!)
  end

  # check if user have role_name
  def has_role?(role_name)
    roles_name = Array.wrap(role_name)
    puts "-------------------------------"
    puts roles_name
    puts "-------------------------------"
    role_unknown = roles_name - Role::AVAILABLE_ROLES
    if role_unknown.any?
     raise "#{role_unknown} role doesnt exist"
    end

    self.user_roles.where(role_name: role_name).exists?
  end

  # check if user have role_name in a list of role_names
  def has_role_in_roles_list?(role_name_list)
    has_role?(role_name_list)
  end

  def get_roles
    # self.user_roles.map{|role| role[:role_name]} is the same as : self.user_roles.pluck(:role_name)
    self.user_roles.pluck(:role_name)
  end


  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
