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

  validates :donor_name, :phone_number, :donation_type, :donated, presence: true
  validates :amount, numericality: { only_integer: true }, allow_nil: true
end
