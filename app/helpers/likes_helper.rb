module LikesHelper
  def render_likes(likeable)
    if likeable.users_who_like_it.include? current_user
      render 'likes/unlike', likeable: likeable
    else
      render 'likes/like', likeable: likeable
    end
  end
end
