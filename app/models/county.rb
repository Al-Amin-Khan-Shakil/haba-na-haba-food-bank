class County < ApplicationRecord
  belongs_to :district
  has_many :sub_counties, dependent: :destroy
  has_many :family_beneficiaries, dependent: :nullify

  accepts_nested_attributes_for :sub_counties, allow_destroy: true
  validates :name, presence: true
end
