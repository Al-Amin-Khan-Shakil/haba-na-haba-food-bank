class County < ApplicationRecord
  belongs_to :district
  has_many :sub_counties, dependent: :destroy

  accepts_nested_attributes_for :sub_counties, allow_destroy: true
  validates :name, presence: true
end
