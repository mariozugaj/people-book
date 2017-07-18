class HomeController < ApplicationController
  def index
    @new_status_update = StatusUpdate.new
    @feed =
      StatusUpdate.includes([author: :profile], comments: [author: :profile])
                  .where('author_id IN (:friends_ids) OR author_id = :user_id',
                         friends_ids: current_user.friends_ids,
                         user_id: current_user.id)
                  .order(created_at: :desc)
                  .page params[:page]
  end
end
