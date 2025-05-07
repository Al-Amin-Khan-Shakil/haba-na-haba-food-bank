class FamilyBeneficiary < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :request, optional: true
  belongs_to :event, optional: true
  belongs_to :branch, optional: true

  validates :phone_number, presence: true, format: { with: /\A\+?[0-9]+\z/, message: 'Must be a valid phone number' }
  validates :family_members, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true
  validates :male, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true
  validates :female, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true
  validates :children, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true
  validates :case_name, presence: true
  validates :case_description, presence: true
end
