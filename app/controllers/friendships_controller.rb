# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :set_friend, only: :create
  before_action :set_friendship, only: %i[update destroy]
  after_action :send_notification, only: :update

  def index
    @user = User.find_by_slug(params[:user_id])
    @friends = @user.friends.includes(:profile).page(params[:page])
  end

  def create
    if current_user.friend_request(@friend)
      flash[:success] = "Friend request to #{@friend.name} sent!"
    else
      flash[:alert] = "We couldn't send friend request to #{@friend.name}!"
    end
    redirect_to request.referrer || @friend
  end

  def update
    if current_user.accept_request(@friendship.friend)
      flash[:success] = "You and #{@friendship.friend.name} are now friends"
    else
      flash[:alert] = "We couldn\'t accept friend request from #{@friendship.friend.name}"
    end
    redirect_to request.referrer || home_path
  end

  def destroy
    friend = @friendship.friend
    if current_user.remove_friend(friend)
      flash[:success] = 'Removed!'
    else
      flash[:alert] = "We couldn\'t remove #{@friend.name} as your friend"
    end
    redirect_to request.referrer || friend
  end

  private

  def friendship_params
    params.permit(:friend_id, :id).to_h
  end

  def set_friend
    @friend = User.find_by_slug(friendship_params[:friend_id])
  end

  def set_friendship
    @friendship = Friendship.find_by_slug(friendship_params[:id])
  end

  def send_notification
    Notification.create(recipient: @friendship.friend,
                        actor: current_user,
                        action: 'accepted',
                        notifiable: @friendship)
  end
end
