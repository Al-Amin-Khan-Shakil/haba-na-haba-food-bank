class FamilyBeneficiary < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :request
  belongs_to :event, optional: true

  validates :phone_number, presence: true, format: { with: /\A\+?[0-9]+\z/, message: 'Must be a valid phone number' }
  validates :family_members, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true
  validates :male, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true
  validates :female, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true
  validates :children, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true

  validates :adult_age_range, presence: true
  validates :children_age_range, presence: true

  validates :district_id, :county_id, :sub_county_id, :request_id, presence: true

  validates :address_note, presence: true, length: { maximum: 255 }
  validates :village, presence: true, length: { maximum: 255 }
  validates :parish, presence: true, length: { maximum: 255 }

  validates :case_name, presence: true, length: { maximum: 255 }
  validates :case_description, presence: true, length: { maximum: 500 }

  validates :fathers_name, presence: true, length: { maximum: 255 }
  validates :mothers_name, presence: true, length: { maximum: 255 }

  validates :fathers_occupation, presence: true, length: { maximum: 255 }
  validates :mothers_occupation, presence: true, length: { maximum: 255 }

  validates :number_of_meals_home, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true
  validates :number_of_meals_school, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true

  validates :basic_FEH, presence: true, length: { maximum: 255 }
  validates :basic_FES, presence: true, length: { maximum: 255 }
end
