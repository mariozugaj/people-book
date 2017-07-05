class HomeController < ApplicationController
  def index
    @new_status_update = StatusUpdate.new
  end
end
