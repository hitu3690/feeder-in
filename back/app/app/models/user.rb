class User < ApplicationRecord
  has_many :feeds

  has_secure_password
end
