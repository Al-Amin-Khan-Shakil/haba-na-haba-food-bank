class Event < ApplicationRecord
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county

  has_many :event_users, dependent: :destroy
  has_many :users, through: :event_users

  validates :title, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, 'must be after or on the same day as start date')
    end
  end
end
