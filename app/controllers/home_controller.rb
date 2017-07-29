class HomeController < ApplicationController
  def index
    @new_status_update = StatusUpdate.new
    @feed = current_user.feed.page params[:page]
  end
end
