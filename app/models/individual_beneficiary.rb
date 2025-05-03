class IndividualBeneficiary < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :request, optional: true
  belongs_to :branch, optional: true
  belongs_to :event, optional: true

  GENDERS = { male: 1, female: 2, other: 3 }.freeze

  validates :name, :case_name, :case_description, presence: true
  validates :phone_number, presence: true, format: { with: /\A\+?[0-9]+\z/, message: 'Must be a valid phone number' }
  validates :gender, presence: true, inclusion: { in: GENDERS.values, message: '%<value>s is not a valid gender' }

  GENDERS.each do |gender_name, value|
    define_method "#{gender_name}?" do
      gender == value
    end
  end
end
