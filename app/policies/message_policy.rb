class MessagePolicy
  attr_reader :user, :message

  def initialize(user, message)
    @user = user
    @message = message
  end

  def create?
    friend?
  end

  private

  def friend?
    user.friends_with? message.receiver
  end
end
