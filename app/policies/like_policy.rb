class LikePolicy
  attr_reader :user, :like

  def initialize(user, like)
    @user = user
    @like = like
  end

  def create?
    friend_or_self?
  end

  def destroy?
    owner?
  end

  private

  def friend_or_self?
    (user.friend_with? like.likeable.author) || user == like.likeable.author
  end

  def owner?
    user == like.user
  end
end
