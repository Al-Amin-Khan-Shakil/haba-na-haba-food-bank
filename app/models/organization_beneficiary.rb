class OrganizationBeneficiary < ApplicationRecord
  belongs_to :county
  belongs_to :sub_county
  belongs_to :district
  belongs_to :branch, optional: true
  belongs_to :request, optional: true
  belongs_to :event, optional: true

  validates :organization_name, :case_name, :case_description, presence: true
  validates :phone_number, presence: true, format: { with: /\A\+?[0-9]+\z/, message: 'Must be a valid phone number' }
end
