class UsersController < ApplicationController
  def show
    @user = User.includes(:profile).find(params[:id])
    @new_status_update = StatusUpdate.new
    @feed = StatusUpdate.includes(author: :profile)
                        .where(author: @user)
                        .page(params[:page])
  end
end
