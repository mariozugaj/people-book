class HomeController < ApplicationController
  def index
    @new_status_update ||= StatusUpdate.new
    @feed =
      StatusUpdate.includes([{ author: :profile }, :likers])
                  .where(author_id: current_user.friends_ids)
                  .order(created_at: :desc)
                  .page params[:page]
  end
end
