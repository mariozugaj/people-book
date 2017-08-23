require 'test_helper'

class FriendshipInterfaceTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :maymie
    @friend = users :ronny
    @pending_friend = users :cole
    @new_friend = users :antonina
  end

  test 'does not render any friendship button if user == self' do
    log_in_as @user
    get user_path(@user)
    assert_select 'a[class = \'friendship_button\']',
                  text: 'Add friend',
                  count: 0
    assert_select 'a[class = \'friendship_button\']',
                  text: 'Friends',
                  count: 0
    assert_select 'span[class = \'friendship_button\']',
                  text: 'Friend request sent',
                  count: 0

    get user_friendships_path(@friend)
    assert_select 'div[class = \'ui raised card\']', count: 1 do
      assert_select 'span[class = \'right floated\'] a[class = \'friendship_button\']',
                    text: 'Add friend',
                    count: 0
      assert_select 'span[class = \'right floated\'] a[class = \'friendship_button\']',
                    text: 'Friends',
                    count: 0
      assert_select 'span[class = \'right floated\'] span[class = \'friendship_button\']',
                    text: 'Friend request sent',
                    count: 0
    end
  end

  test 'renders add friend button if not friends' do
    log_in_as @user
    get user_path(@new_friend)
    assert_select 'a[class = \'friendship_button\']',
                  text: 'Add friend',
                  count: 1
  end

  test 'renders remove friend button if friends' do
    log_in_as @user
    get user_path(@friend)
    assert_select 'a[class = \'friendship_button\']',
                  text: 'Friends',
                  count: 1
  end

  test 'renders friend request sent if pending' do
    log_in_as @user
    get user_path(@pending_friend)
    assert_select 'span[class = \'friendship_button\']',
                  text: 'Pending friend request',
                  count: 1
  end

  test 'renders pending request if pending request from same user' do
    log_in_as @user
    get user_path(@pending_friend)
    assert_select 'span[class = \'friendship_button\']',
                  text: 'Pending friend request',
                  count: 1
    log_in_as @pending_friend
    get user_path(@user)
    assert_select 'span[class = \'friendship_button\']',
                  text: 'Pending friend request',
                  count: 1
  end

  test 'adding new friend' do
    log_in_as @user
    get user_path(@new_friend)
    assert_difference 'Friendship.count', 2 do
      post user_friendships_path(@user), params: { friend_id: @new_friend.slug }
    end
    assert_redirected_to user_path(@new_friend)
    follow_redirect!
    assert_select 'span[class = \'friendship_button\']',
                  text: 'Pending friend request',
                  count: 1

    log_in_as @new_friend
    get home_path
    assert_difference ['@user.friends.count', '@new_friend.friends.count'], 1 do
      patch user_friendship_path(@new_friend, Friendship.find_relation(@new_friend, @user).first)
    end

    assert_equal 1, @user.notifications.count
    assert_equal 0, @new_friend.notifications.count
    assert_redirected_to home_path
    follow_redirect!
    assert_equal "You and #{@user.name} are now friends", flash[:success]
    get user_path(@user)
    assert_select 'a[class = \'friendship_button\']',
                  text: 'Friends',
                  count: 1
  end

  test 'removing a friend' do
    log_in_as @user
    get user_path(@friend)
    assert_difference 'Friendship.count', -2 do
      delete user_friendship_path(@user, Friendship.find_relation(@user, @friend).first)
    end
    assert_redirected_to user_path(@friend)
    follow_redirect!
    assert_equal 'Removed!', flash[:success]
    assert_select 'a[class = \'friendship_button\']',
                  text: 'Add friend',
                  count: 1
  end

  test 'declining a friend request' do
    log_in_as @pending_friend
    get home_path
    assert_select 'div[class = \'right pointing ui label red\']', text: '1'
    assert_difference 'Friendship.count', -2 do
      delete user_friendship_path(@user, Friendship.find_relation(@pending_friend, @user).first),
             headers: { 'HTTP_REFERER' => home_path }
    end
    assert_redirected_to home_path
    follow_redirect!
    assert_equal 'Removed!', flash[:success]

    log_in_as @user
    get user_path(@pending_friend)
    assert_select 'a[class = \'friendship_button\']',
                  text: 'Add friend',
                  count: 1
  end

  test 'user friends layout' do
    log_in_as @user
    get user_friendships_path(@user)

    assert_select 'div#friend_count', text: '2', count: 1
    assert_select 'div[class = \'ui raised card\']', count: 2 do
      assert_select 'a.image[href=?]', user_path(@friend), count: 1
      assert_select 'img[src=?]', @friend.profile.avatar.url(:normal), count: 1
      assert_select 'a.header[href=?]', user_path(@friend), text: 'Ronny Miller', count: 1
      assert_select 'span.date', text: 'Joined 5 days ago', count: 1
      assert_select 'a[href=?]', user_friendships_path(@friend), text: '1 friend', count: 1
      assert_select 'a span', text: 'Friends'
    end
  end
end