class CommentPolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    @user = user
    @comment = comment
  end

  def create?
    (user.friend_with? comment.commentable.author) || user == comment.commentable.author
  end

  def destroy?
    owner?
  end

  private

  def owner?
    user == comment.author
  end
end
