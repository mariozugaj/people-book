require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    @user = users(:maymie)
    @likeable = status_updates(:first)
    @like = Like.new(user: @user, likeable: @likeable)
  end

  test 'should be valid' do
    assert @like.valid?
  end

  test 'user can\'t like same likeable more than once' do
    @like.save
    assert_no_difference 'Like.count' do
      second_like = Like.new(user: @user, likeable: @likeable)
      second_like.save
    end
  end
end