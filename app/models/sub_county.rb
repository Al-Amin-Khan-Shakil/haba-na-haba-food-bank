class SubCounty < ApplicationRecord
  belongs_to :county
  belongs_to :district
  validates :name, presence: true
end
