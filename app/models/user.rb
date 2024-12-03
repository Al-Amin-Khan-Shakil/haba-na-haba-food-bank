class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :validatable

  has_one_attached :profile_picture
end
