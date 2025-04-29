class Request < ApplicationRecord
  belongs_to :branch
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :user

  has_one :donation, dependent: :destroy

  REQUEST_TYPES = { food_request: 1, donation_request: 2 }.freeze

  validates :name, presence: true
  validates :phone_number, presence: true
  validates :request_type, presence: true, inclusion: { in: REQUEST_TYPES.values, message: '%<value>s is not a valid request type' }

  REQUEST_TYPES.each do |request_type_name, value|
    define_method "#{request_type_name}?" do
      request_type == value
    end
  end
end
