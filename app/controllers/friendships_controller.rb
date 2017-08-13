class FriendshipsController < ApplicationController
  before_action :set_friendship, only: %i[update destroy]
  after_action :send_notification, only: :update
  after_action :delete_other_request, only: :update

  def index
    @user = User.find_by_slug(params[:user_id])
    @friends = @user.friends.includes(:profile).page(params[:page])
  end

  def create
    @friendship = current_user.sent_friend_requests.build(friendship_params)
    @friend = @friendship.friend
    if @friendship.save
      flash[:success] = "You sent a friend request to #{@friend.name}"
    else
      flash[:alert] = "We couldn\'t send friend request to #{@friend.name}"
    end
    redirect_to request.referrer || @friend
  end

  def update
    if @friendship.update(accepted: true)
      flash[:success] = "You and #{@friendship.user.name} are now friends"
    else
      flash[:alert] = "We couldn\'t accept friend request from #{@friendship.user.name}"
    end
    redirect_to request.referrer || root_path
  end

  def destroy
    @friend = if @friendship.friend == current_user
                @friendship.user
              else
                @friendship.friend
              end
    if @friendship.destroy
      flash[:success] = "You are no longer friends with #{@friend.name}" if @friendship.accepted
    else
      flash[:alert] = "We couldn\'t remove #{@friend.name} as your friend"
    end
    redirect_to request.referrer || @friend
  end

  private

  def set_friendship
    @friendship = Friendship.find_by_slug(params[:id])
  end

  def friendship_params
    params.require(:friendship).permit(:user_id, :friend_id)
  end

  def send_notification
    Notification.create(recipient: @friendship.user,
                        actor: current_user,
                        action: 'accepted',
                        notifiable: @friendship)
  end

  def delete_other_request
    if request = @friendship.user.received_friend_requests.where(user: @friendship.friend).first
      request.destroy
    end
  end
end
