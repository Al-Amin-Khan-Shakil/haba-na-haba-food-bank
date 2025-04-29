class Request < ApplicationRecord
  belongs_to :branch
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :user

  has_one :donation, dependent: :destroy

  enum request_type: {
    food_request: 1,
    donation_request: 2
  }

  validates :name, :phone_number, :request_type, presence: true
end
