class SubCounty < ApplicationRecord
  belongs_to :county

  has_many :family_beneficiaries, dependent: :nullify
  has_many :individual_beneficiaries, dependent: :destroy
  has_many :events, dependent: :nullify
  has_many :inventories, dependent: :nullify
  has_many :requests, dependent: :nullify
  has_many :organization_beneficiaries, dependent: :nullify

  validates :name, presence: true
end
