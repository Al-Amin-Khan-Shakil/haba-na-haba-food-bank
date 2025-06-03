class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.includes(:notifiable).order(created_at: :desc)
  end

  def show
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_read!
    redirect_to polymorphic_path(@notification.notifiable), notice: 'Notification marked as read.'
  rescue ActiveRecord::RecordNotFound
    redirect_to notifications_path, alert: 'Notification not found.'
  end
end
