class Branch < ApplicationRecord
  has_many :districts, dependent: :nullify
  has_many :organization_beneficiaries, dependent: :nullify
  validates :name, presence: true
  validates :phone_number, presence: true, format: { with: /\A\+?[0-9]+\z/, message: 'Must be a valid phone number' }
  validates :address, presence: true
end
