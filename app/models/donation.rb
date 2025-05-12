class Donation < ApplicationRecord
  belongs_to :request

  enum donation_type: {
    fresh_food: 1,
    dry_food: 2,
    cloth: 3,
    money: 4,
    medicine: 5,
    others: 6
  }, _prefix: :donation

  enum donor_type: {
    individual: 1,
    private_organization: 2,
    government_organization: 3,
    non_government_organization: 4,
    international_organization: 5,
    others: 6
  }, _prefix: :donor

  validates :donation_type, presence: true
end
