class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @new_status_update = StatusUpdate.new
    @feed = @user.status_updates
  end
end
