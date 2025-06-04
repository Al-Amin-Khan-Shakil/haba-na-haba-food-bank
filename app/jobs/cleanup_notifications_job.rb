class CleanupNotificationsJob < ApplicationJob
  queue_as :default

  def perform
    Notification.where(notifiable_type: 'Request').where.not(
      notifiable_id: Request.select(:id)
    ).destroy_all

    Notification.where(notifiable_type: 'Event').where.not(
      notifiable_id: Event.select(:id)
    ).destroy_all
  end
end
