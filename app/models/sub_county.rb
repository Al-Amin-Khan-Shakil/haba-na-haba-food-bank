class SubCounty < ApplicationRecord
  belongs_to :county
  has_many :family_beneficiaries, dependent: :nullify

  validates :name, presence: true
end
