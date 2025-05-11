class SubCounty < ApplicationRecord
  belongs_to :county

  has_many :family_beneficiaries, dependent: :nullify
  has_many :individual_beneficiaries, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :requests, dependent: :nullify


  validates :name, presence: true
end
