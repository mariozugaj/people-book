require 'test_helper'

class LikeInterfaceTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @user = users(:maymie)
    @friend = users(:ronny)
    @not_friend = users(:cole)
    @status_update = @user.status_updates.first
    @image = @user.images.first
    @comment = @user.comments.first
  end

  test 'can like own image, status update or comment' do
    log_in_as @user

    get image_path(@image)
    assert_difference 'Like.count', 1 do
      post image_likes_path(@image, format: :js),
           params: { user_id: @user.id }
    end

    get user_path(@user)
    assert_difference 'Like.count', 1 do
      post status_update_likes_path(@status_update, format: :js),
           params: { user_id: @user.id }
    end
    assert_difference 'Like.count', 1 do
      post comment_likes_path(@comment, format: :js),
           params: { user_id: @user.id }
    end
  end

  test 'can unlike own likes' do
    log_in_as @user
    get image_path(@image)
    assert_difference 'Like.count', -1 do
      delete like_path(likes(:third), format: :js)
    end

    get user_path(@user)
    assert_difference 'Like.count', -1 do
      delete like_path(likes(:first), format: :js)
    end
    assert_difference 'Like.count', -1 do
      delete like_path(likes(:second), format: :js)
    end
  end

  test 'cannot unlike someone else\'s likes' do
    log_in_as @friend
    get image_path(@image)
    assert_no_difference 'Like.count' do
      delete like_path(likes(:third), format: :js)
    end

    get user_path(@user)
    assert_no_difference 'Like.count' do
      delete like_path(likes(:first), format: :js)
    end
    assert_no_difference 'Like.count' do
      delete like_path(likes(:second), format: :js)
    end
  end

  test 'can like if not a friend' do
    log_in_as @not_friend

    get image_path(@image)
    assert_difference 'Like.count', 1 do
      post image_likes_path(@image, format: :js),
           params: { user_id: @not_friend.id }
    end
  end

  test 'like creation sends a notification' do
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true

    log_in_as @friend
    get image_path(@image)

    assert_performed_jobs 1 do
      post image_likes_path(@image, format: :js),
           params: { user_id: @friend.id }
    end

    assert_equal 1, @user.notifications.count
  end
end
