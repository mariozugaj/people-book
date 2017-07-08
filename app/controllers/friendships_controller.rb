class FriendshipsController < ApplicationController

  def create
    @friendship = current_user.sent_friend_requests.build(friendship_params)
    @friend = @friendship.friend
    if @friendship.save
      flash[:success] = "You sent a friend request to #{@friend.name}"
      respond_to do |format|
        format.html { redirect_to @friend }
        format.js
      end
    else
      flash[:alert] = "We couldn\'t send friend request to #{@friend.name}"
      respond_to do |format|
        format.html { redirect_to @friend }
        format.js { render 'shared/flash_js' }
      end
    end
  end

  def update

  end

  def destroy
    @user = User.find(params[:id])
    @friendship = Friendship.where('user_id = :user OR friend_id = :user', user: @user.id).first
    if @friendship.destroy
      flash[:success] = "You are no longer friends with #{@user.name}"
      p flash
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
    else
      flash[:alert] = "We couldn\'t remove #{@user.name} as your friend"
      respond_to do |format|
        format.html { redirect_to @user }
        format.js { render 'shared/flash_js' }
      end
    end
  end

  private

  def friendship_params
    params.require(:friendship).permit(:id, :friend_id)
  end
end
