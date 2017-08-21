require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  def setup
    @user1 = users(:maymie)
    @user2 = users(:ronny)
  end

  test 'user and friend should be present' do
    friendship = Friendship.new
    refute friendship.valid?
  end
end
