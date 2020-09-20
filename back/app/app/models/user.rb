class User < ApplicationRecord
  include DeviseTokenAuth::Concerns::User #ここだけがDevise Token Auth用

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :feeds

  has_secure_password
end
