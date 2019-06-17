# frozen_string_literal: true

require 'test_helper'

class CommentInterfaceTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @user = users(:maymie)
    @friend = users(:ronny)
    @not_friend = users(:cole)
    @status_update = @user.status_updates.first
    @image = @user.images.first
    @comment = @user.comments.first
  end

  test 'can comment on own image' do
    log_in_as @user
    get image_path(@image)
    assert_difference 'Comment.count', 1 do
      post image_comments_path(@image, format: :js),
           params: { comment: { author_id: @user.id,
                                text: 'It’s no use going back to yesterday, because I was a different person then.' } }
    end
  end

  test 'can comment on own status update' do
    log_in_as @user
    get user_path(@user)
    assert_difference 'Comment.count', 1 do
      post status_update_comments_path(@status_update, format: :js),
           params: { comment: { author_id: @user.id,
                                text: 'It’s no use going back to yesterday, because I was a different person then.' } }
    end
  end

  test 'can comment on friends image' do
    log_in_as @friend
    get image_path(@image)
    assert_difference 'Comment.count', 1 do
      post image_comments_path(@image, format: :js),
           params: { comment: { author_id: @friend.id,
                                text: 'It’s no use going back to yesterday, because I was a different person then.' } }
    end
  end

  test 'can comment on friends status_update' do
    log_in_as @friend
    get user_path(@user)
    assert_difference 'Comment.count', 1 do
      post status_update_comments_path(@status_update, format: :js),
           params: { comment: { author_id: @friend.id,
                                text: 'It’s no use going back to yesterday, because I was a different person then.' } }
    end
  end

  test 'cannot comment on image if not a friend' do
    log_in_as @not_friend
    get image_path(@image)
    assert_no_difference 'Comment.count' do
      post image_comments_path(@image, format: :js),
           params: { comment: { author_id: @not_friend.id,
                                text: 'It’s no use going back to yesterday, because I was a different person then.' } },
           headers: { 'HTTP_REFERER' => image_path(@image) }
    end
    assert_equal 'Akward! Seems like you wanted to do something you are not allowed to.', flash[:alert]
    assert_redirected_to image_path(@image)
  end

  test 'cannot comment on status_update if not a friend' do
    log_in_as @not_friend
    get user_path(@user)
    assert_no_difference 'Comment.count' do
      post status_update_comments_path(@status_update, format: :js),
           params: { comment: { author_id: @not_friend.id,
                                text: 'It’s no use going back to yesterday, because I was a different person then.' } }
    end
    assert_equal 'Akward! Seems like you wanted to do something you are not allowed to.', flash[:alert]
    assert_redirected_to home_path
  end

  test 'can delete own comment' do
    log_in_as @user
    get user_path(@user)
    assert_difference 'Comment.count', -1 do
      delete comment_path(@comment, format: :js)
    end
  end

  test 'cannot delete someone else\'s comment' do
    log_in_as @friend
    get user_path(@user)
    assert_no_difference 'Comment.count' do
      delete comment_path(@comment, format: :js)
    end
    assert_equal 'Akward! Seems like you wanted to do something you are not allowed to.', flash[:alert]
    assert_redirected_to home_path
  end

  test 'comment creation sends a notification' do
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true

    log_in_as @friend
    get image_path(@image)

    assert_performed_jobs 1 do
      post image_comments_path(@image, format: :js),
           params: { comment: { author_id: @friend.id,
                                text: 'It’s no use going back to yesterday, because I was a different person then.' } }
    end

    recipients = (@image.commenters +
                  [@image.author] +
                  @image.likers).uniq -
                 [@friend]

    assert_equal 1, recipients.size
    recipients.each do |recipient|
      assert_equal 1, recipient.notifications.count
    end
  end
end
