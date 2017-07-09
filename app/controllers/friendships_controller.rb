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
    @friendship = Friendship.find(params[:id])
    if @friendship.update(accepted: true)
      flash[:success] = "You and #{@friendship.user.name} are now friends"
    else
      flash[:alert] = "We couldn\'t accept friend request from #{@friendship.user.name}"
    end
    redirect_to request.referrer || root_path
  end

  def destroy
    @user = User.find(params[:user_id])
    @friendship = Friendship.find(params[:id])
    if @friendship.destroy
      flash[:success] = "You are no longer friends with #{@user.name}" if @friendship.accepted
      respond_to do |format|
        format.html { redirect_to request.referrer || @user }
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
    params.require(:friendship).permit(:user_id, :friend_id)
  end
end
