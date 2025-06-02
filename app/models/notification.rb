class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }

  validates :notifiable_type, inclusion: { in: %w[Request Event], message: "%{value} is not a valid notification type" }

  def read?
    read_at.present?
  end

  def mark_as_read!
    update(read_at: Time.current) unsess read?
  end
end
