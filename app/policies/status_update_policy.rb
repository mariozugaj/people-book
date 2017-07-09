class StatusUpdatePolicy
  attr_reader :user, :status_update

  def initialize(user, status_update)
    @user = user
    @status_update = status_update
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
    (user.friend_with? status_update.author) || user == status_update.author
  end

  private

  def owner?
    user == status_update.author
  end
end
