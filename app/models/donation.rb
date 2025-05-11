class Donation < ApplicationRecord
  belongs_to :request

  enum donation_type: {
    fresh_food: 1,
    dry_food: 2,
    cloth: 3,
    money: 4,
    medicine: 5,
    others: 6
  }

  validates :donation_type, presence: true
end
