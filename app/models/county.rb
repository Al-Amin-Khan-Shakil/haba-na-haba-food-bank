class County < ApplicationRecord
  belongs_to :district

  has_many :sub_counties, dependent: :destroy
  has_many :family_beneficiaries, dependent: :nullify
  has_many :individual_beneficiaries, dependent: :nullify
  has_many :events, dependent: :destroy
  has_many :requests, dependent: :nullify

  accepts_nested_attributes_for :sub_counties, allow_destroy: true
  validates :name, presence: true
end
