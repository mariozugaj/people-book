class HomeController < ApplicationController
  def index
    @new_status_update = StatusUpdate.new
    @feed = StatusUpdate.includes([author: :profile], comments: [author: :profile])
                        .order(created_at: :desc)
                        .all
  end
end
