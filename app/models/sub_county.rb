class SubCounty < ApplicationRecord
  belongs_to :county
  validates :name, presence: true
end
