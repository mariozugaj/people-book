class UsersController < ApplicationController

  def show
    @user = User.includes(:profile).find(params[:id])
    @new_status_update = StatusUpdate.new
    @feed = @user.status_updates.includes(:author, comments: [:author, author: :profile])
  end
end
