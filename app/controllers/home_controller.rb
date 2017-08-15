class HomeController < ApplicationController
  def index
    @new_status_update ||= StatusUpdate.new
    @feed =
      StatusUpdate.includes([{ author: :profile }, :likers])
                  .where(author: current_user.friends)
                  .ordered
                  .page(params[:page])
                  .per(6)
    @activity =
      Notification.includes([:recipient, :notifiable, actor: :profile])
                  .where.not(actor: current_user)
                  .where(actor: current_user.friends)
                  .where('created_at > ?', 10.hours.ago)
                  .order(created_at: :desc)
                  .limit(10)
  end
end
