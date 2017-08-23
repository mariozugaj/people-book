require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user1 = User.create!(name: 'John Doe', email: 'john@example.com', password: 'password123')
    @user2 = User.create!(name: 'Joana Doe', email: 'joana@example.com', password: 'password123')
  end

  test 'should be valid' do
    assert @user1.valid?
  end

  test 'name should be present' do
    @user1.name = nil
    refute @user1.valid?
  end

  test 'email should be present' do
    @user1.email = nil
    refute @user1.valid?
  end

  test 'password should be present' do
    @user1.password = ' '
    refute @user1.valid?
  end

  test 'gets created from facebook authorization' do
    assert_difference 'User.count', 1 do
      User.from_omniauth(mock_auth_hash_new)
    end
  end

  test 'gets found from facebook authorization' do
    auth_user = User.from_omniauth(mock_auth_hash_existing)
    assert_equal auth_user, users(:maymie)
  end

  test 'can send friend request' do
    assert_difference 'Friendship.count', 2 do
      @user1.friend_request(@user2)
    end
  end

  test 'can\'t send friend request to self' do
    assert_no_difference 'Friendship.count' do
      @user1.friend_request(@user1)
    end
  end

  test 'can\'t send friend request to (pending) friend' do
    @user1.friend_request(@user2)
    assert_no_difference 'Friendship.count' do
      @user1.friend_request(@user2)
    end
  end

  test 'has pending friends' do
    @user1.friend_request(@user2)
    assert_includes @user1.pending_friends, @user2
  end

  test 'has requested friends' do
    @user1.friend_request(@user2)
    assert_includes @user2.requested_friends, @user1
  end

  test 'can accept friend request' do
    @user1.friend_request(@user2)
    assert_difference ['@user1.friends.count', '@user2.friends.count'], 1 do
      @user2.accept_request(@user1)
    end
  end

  test 'can\'t accept self friend request' do
    @user1.friend_request(@user2)
    assert_no_difference '@user1.friends.count' do
      @user1.accept_request(@user2)
    end
  end

  test 'can\'t accept if no friend request' do
    assert_raises NoMethodError do
      @user1.accept_request(@user2)
    end
  end

  test 'can decline friend request' do
    @user1.friend_request(@user2)
    assert_difference 'Friendship.count', -2 do
      @user2.decline_request(@user1)
    end
  end

  test 'can\'t decline if no friend request' do
    assert_raises NoMethodError do
      @user1.decline_request(@user2)
    end
  end

  test 'can remove friend' do
    @user1.friend_request(@user2)
    @user2.accept_request(@user1)
    assert_difference 'Friendship.count', -2 do
      @user1.remove_friend(@user2)
    end
  end

  test 'can\'t remove if no friendship' do
    assert_raises NoMethodError do
      @user1.remove_friend(@user2)
    end
  end

  test 'checks if friendship exists' do
    @user1.friend_request(@user2)
    @user2.accept_request(@user1)
    assert @user1.friends_with?(@user2)
    assert @user2.friends_with?(@user1)
  end

  test 'checks if friendship does not exist' do
    refute @user1.friends_with?(@user2)
    refute @user2.friends_with?(@user1)
  end

  test 'checks if friendship exist if it is pending' do
    @user1.friend_request(@user2)
    refute @user1.friends_with?(@user2)
    refute @user2.friends_with?(@user1)
  end

  test 'unread conversations count' do
    assert_equal 1, users(:maymie).unread_conversations_count
    assert_equal 0, users(:ronny).unread_conversations_count
  end
end
