class Donation < ApplicationRecord
  belongs_to :request

  TYPES = { fresh_food: 1, dry_food: 2, cloth: 3, money: 4, medecine: 5, others: 6 }.freeze

  validates :name, presence: true
  validates :phone_number, presence: true
  validates :type, presence: true, inclusion: { in: RYPES.values, message: '%<value>s is not a valid donation' }
  validates :donated, presence: true

  TYPES.each do |type_name, value|
    define_method "#{type_name}?" do
      type == value
    end
  end
end
