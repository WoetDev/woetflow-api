class User < ApplicationRecord
  has_secure_password
  has_many :posts

  validates :full_name, 
            presence: true, 
            uniqueness: { case_sensitive: false }

  def self.authenticate(username, password)
    user = User.find_by(full_name: username)
    user && user.authenticate(password)
  end
end
