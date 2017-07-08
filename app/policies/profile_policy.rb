class ProfilePolicy
  attr_reader :user, :profile

  def initialize(user, profile)
    @user = user
    @profile = profile
  end

  def edit?
    owner?
  end

  def update?
    owner?
  end

  private

  def owner?
    user == profile.user
  end
end
