class SubCounty < ApplicationRecord
  belongs_to :county
  validates :name, presence: true
  has_many :family_beneficiaries, dependent: :nullify
  has_many :organization_beneficiaries, dependent: :nullify
end
