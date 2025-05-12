class Inventory < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :donation
  belongs_to :request, optional: true
  belongs_to :branch, optional: true
  belongs_to :event, optional: true

  validates :name, :expire_date, :amount, :cost_of_item, :collection_place, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :cost_of_item, numericality: { greater_than_or_equal_to: 0 }
  validates :expire_date, date: { after_or_equal_to: proc {
    Date.today
  }, message: 'must be after or equal to today' }
end
