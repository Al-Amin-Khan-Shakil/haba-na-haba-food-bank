class Inventory < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :donation, optional: true
  belongs_to :request, optional: true
  belongs_to :branch, optional: true
  belongs_to :event, optional: true

  validates :name, :expire_date, :amount, :cost_of_item, :collection_place, presence: true
  validates :phone_number, presence: true, format: { with: /\A\+?[0-9]+\z/, message: 'Must be a valid phone number' }
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :cost_of_item, numericality: { greater_than_or_equal_to: 0 }
  validate :expire_date_must_be_in_future

  private

  def expire_date_must_be_in_future
    return unless expire_date.present? && expire_date <= Date.today

    errors.add(:expire_date, 'must be after today')
  end
end
