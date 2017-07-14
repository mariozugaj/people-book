class NotificationsController < ApplicationController
  def index
    @notifications = Notification.where(recipient: current_user).recent
    @all_notifications = Notification.where(recipient: current_user)
                                     .order(created_at: :desc)

  end

  def mark_as_read
    @notifications = Notification.where(recipient: current_user).unread
    @notifications.update_all(read_at: Time.zone.now)
    render json: { success: true }
  end

  def clear
    notifications = Notification.where(recipient: current_user).read
    notifications.destroy_all
    flash[:success] = 'Notifications cleared'
    redirect_to request.referrer || notifications_path
  end
end
