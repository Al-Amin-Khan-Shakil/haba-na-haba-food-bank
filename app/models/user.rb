class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :validatable

  has_one_attached :avatar
end
