class LikePolicy
  attr_reader :user, :like

  def initialize(user, like)
    @user = user
    @like = like
  end

  def destroy?
    owner?
  end

  private

  def owner?
    user == like.user
  end
end
