class HomeController < ApplicationController
  def index
    @new_status_update = StatusUpdate.new
    @feed =
      StatusUpdate.includes({ author: [:profile] }, :users_who_like_it)
                  .where(author_id: current_user.friends_ids << current_user.id)
                  .order(created_at: :desc)
                  .page params[:page]
  end
end
