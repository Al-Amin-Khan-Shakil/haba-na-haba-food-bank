class OrganizationBeneficiary < ApplicationRecord
  belongs_to :county
  belongs_to :sub_county
  belongs_to :district
  belongs_to :branch, optional: true
  belongs_to :request, optional: true
  belongs_to :event, optional: true

  validates :organization_name, presence: true
  validates :county_id, presence: true
  validates :sub_county_id, presence: true
  validates :phone_number, presence: true
end
