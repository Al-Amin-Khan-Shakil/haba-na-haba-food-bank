class IndividualBeneficiary < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :request, optional: true
  belongs_to :branch, optional: true
  belongs_to :event, optional: true

  enum gender: {
    male: 1,
    female: 2,
    other: 3
  }

  validates :name, :gender, :case_name, :case_description, presence: true
  validates :phone_number, presence: true, format: { with: /\A\+?[0-9]+\z/, message: 'Must be a valid phone number' }
end
