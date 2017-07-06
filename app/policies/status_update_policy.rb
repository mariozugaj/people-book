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

  def comment?
    current_user.friend_with? user
  end

  private

  def owner?
    user == record.user
  end
end
