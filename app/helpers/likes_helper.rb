module LikesHelper
  def render_likes(likeable)
    if likeable.likers.pluck(:id).include? current_user.id
      render 'likes/unlike', likeable: likeable
    else
      render 'likes/like', likeable: likeable
    end
  end
end
