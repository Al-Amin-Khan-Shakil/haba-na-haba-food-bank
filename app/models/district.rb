class District < ApplicationRecord
  has_many :counties, dependent: :destroy
  has_many :sub_counties, through: :counties

  accepts_nested_attributes_for :counties, allow_destroy: true
  validates :name, presence: true
end
