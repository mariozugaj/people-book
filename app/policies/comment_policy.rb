class CommentPolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    @user = user
    @comment = comment
  end

  def create?
    friend? || commentable_owner?
  end

  def destroy?
    owner?
  end

  def like?
    friend? || commentable_owner?
  end

  private

  def friend?
    user.friends_with? comment.commentable.author
  end

  def commentable_owner?
    user == comment.commentable.author
  end

  def owner?
    user == comment.author
  end
end
