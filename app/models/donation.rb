class Donation < ApplicationRecord
  belongs_to :request

  TYPES = { fresh_food: 1, dry_food: 2, cloth: 3, money: 4, medecine: 5, others: 6 }.freeze

  validates :donor_name, presence: true
  validates :phone_number, presence: true
  validates :donation_type, presence: true, inclusion: { in: TYPES.values, message: '%<value>s is not a valid donation' }
  validates :donated, presence: true

  TYPES.each do |donation_type_name, value|
    define_method "#{donation_type_name}?" do
      donation_type == value
    end
  end
end
