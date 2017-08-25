class LikePolicy
  attr_reader :user, :like

  def initialize(user, like)
    @user = user
    @like = like
  end

  def create?
    friend? || likeable_owner?
  end

  def destroy?
    owner?
  end

  private

  def owner?
    user == like.user
  end

  def likeable_owner?
    user == like.likeable.author
  end

  def friend?
    user.friends_with? like.likeable.author
  end
end
