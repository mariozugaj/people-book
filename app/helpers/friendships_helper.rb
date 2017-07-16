module FriendshipsHelper
  def render_friendship(user)
    if current_user.sent_friend_requests.where(friend_id: user.id, accepted: false).any?
      render 'friendships/request_sent', user: user
    elsif current_user.friend_with? user
      render 'friendships/unfriend', user: user
    else
      render 'friendships/add_friend', user: user
    end
  end

  def find_friendship(user)
    current_user.friendships
                .where('user_id = :user_id OR friend_id = :user_id',
                       user_id: user.id)
                .first
  end
end
