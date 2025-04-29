class Request < ApplicationRecord
  belongs_to :branch
  belongs_to :district
  belongs_to :county, optional: true
  belongs_to :sub_county, optional: true
  belongs_to :user, optional: true

  has_one :donation, dependent: :nullify
  accepts_nested_attributes_for :donation

  enum request_type: {
    food_request: 1,
    donation_request: 2
  }

  validates :name, :phone_number, :request_type, presence: true
end
