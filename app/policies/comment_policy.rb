class CommentPolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    @user = user
    @comment = comment
  end

  def create?
    friend_or_self?
  end

  def destroy?
    owner?
  end

  def like?
    friend_or_self?
  end

  private

  def friend_or_self?
    (user.friend_with? comment.commentable.author) ||
      user == comment.commentable.author
  end

  def owner?
    user == comment.author
  end
end
