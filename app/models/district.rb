class District < ApplicationRecord
  belongs_to :branch, optional: true
  has_many :counties, dependent: :destroy
  has_many :family_beneficiaries, dependent: :nullify
  has_many :organization_beneficiaries, dependent: :nullify

  accepts_nested_attributes_for :counties, allow_destroy: true
  validates :name, presence: true
end
