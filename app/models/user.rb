class User < ActiveRecord::Base
   attr_accessible :first_name, :last_name, :email, :password, :password_confirmation
   has_secure_password

   before_save { |user| user.email = email.downcase }

   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
   validates :first_name, presence: true, length: {in: 2..50}
   validates :last_name, presence: true, length: {minimum: 2, maximum: 50}
   validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
   validates :password, presence: true, length: { minimum: 6 }


end
