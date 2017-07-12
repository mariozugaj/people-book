class ImagePolicy
  attr_reader :user, :image

  def initialize(user, image)
    @user = user
    @image = image
  end

  def create?
    true
  end

  def edit?
    owner?
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  def comment?
    friend_or_self?
  end

  private

  def owner?
    user == image.author
  end

  def friend_or_self?
    (user.friend_with? image.author) || user == image.author
  end
end
