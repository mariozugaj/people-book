class HomeController < ApplicationController
  def index
    @new_status_update ||= StatusUpdate.new
    @feed =
      StatusUpdate.includes([{ author: :profile }, :likers])
                  .where(author_id: current_user.friends_ids)
                  .ordered
                  .page(params[:page])
                  .per(6)
    @activity =
      Notification.includes([:recipient, :notifiable, actor: :profile])
                  .where.not(actor: current_user)
                  .where(actor_id: current_user.friends_ids)
                  .where('created_at > ?', 10.hours.ago)
                  .order(created_at: :desc)
                  .limit(10)
  end
end
