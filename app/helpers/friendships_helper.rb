module FriendshipsHelper
  def render_friendship(user)
    friendship = find_friendship(user)
    return render 'friendships/add_friend', user: user if friendship.nil?
    return render(partial: 'friendships/remove_friend', locals: { user: user, friendship: friendship }) if friendship.accepted?
    return render 'friendships/request_sent', user: user if (friendship.pending? || friendship.requested?)
  end

  def find_friendship(friend)
    Friendship.find_relation(current_user, friend).first
  end
end
