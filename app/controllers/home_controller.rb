class HomeController < ApplicationController
  def index
    @new_status_update ||= StatusUpdate.new
    @feed =
      StatusUpdate.includes([{ author: :profile }, :likers])
                  .where(author: [current_user] << current_user.friends)
                  .ordered
                  .page(params[:page])
                  .per(6)
  end
end
