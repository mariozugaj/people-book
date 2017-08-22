require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment = comments(:first)
  end

  test 'should be valid' do
    assert @comment.valid?
  end

  test 'author and commentable should be present' do
    @comment.author = nil
    @comment.commentable = nil
    refute @comment.valid?
  end
end
