class HomeController < ApplicationController
  def index
    @new_status_update = StatusUpdate.new
    @feed = StatusUpdate.includes(:author).all
  end
end
