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

  def feedback?
    friend? || owner?
  end

  private

  def owner?
    user == image.author
  end

  def friend?
    user.friends_with? image.author
  end
end
