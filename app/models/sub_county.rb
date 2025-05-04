class SubCounty < ApplicationRecord
  belongs_to :county
  has_many :individual_beneficiaries, dependent: :destroy
  validates :name, presence: true
end
