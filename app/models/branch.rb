class Branch < ApplicationRecord
  has_many :districts, dependent: :nullify
  has_many :organization_beneficiaries, dependent: :nullify
  has_many :family_beneficiaries, dependent: :nullify
  has_many :individual_beneficiaries, dependent: :nullify
  has_many :inventories, dependent: :nullify
  has_many :users, dependent: :nullify

  validates :name, presence: true
  validates :phone_number, presence: true, format: { with: /\A\+?[0-9]+\z/, message: 'Must be a valid phone number' }
  validates :address, presence: true
end
