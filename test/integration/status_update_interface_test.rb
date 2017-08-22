require 'test_helper'

class StatusUpdateInterfaceTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @user = users(:maymie)
    StatusUpdate.find_each { |s| StatusUpdate.reset_counters(s.id, :comments) }
    StatusUpdate.find_each { |s| StatusUpdate.reset_counters(s.id, :likes) }
  end

  test 'status update invalid submission' do
    log_in_as @user
    get home_path
    assert_response :success
    assert_select 'form.ui.form'
    assert_select 'input[type=file]'

    assert_no_difference 'StatusUpdate.count' do
      post user_status_updates_path(@user), params: { status_update: { text: '' } },
                                            headers: { 'HTTP_REFERER' => home_path }
    end
    assert_equal 'We were unable to save your status update.', flash[:alert]
    assert_redirected_to home_path
  end

  test 'status update valid submission' do
    text = 'It takes courage to grow up and become who you really are.'
    assert_difference 'StatusUpdate.count', 1 do
      write_status_update(text)
    end

    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_match text, response.body
  end

  test 'status update deletion' do
    log_in_as @user
    get user_path(@user)
    assert_select 'a', text: 'Delete'
    first_status_update = @user.status_updates.first
    assert_difference 'StatusUpdate.count', -1 do
      delete status_update_path(first_status_update)
    end
    assert_redirected_to user_path(@user)
  end

  test 'edit status update' do
    log_in_as @user
    get user_path(@user)
    assert_select 'a', text: 'Edit'

    first_status_update = @user.status_updates.first
    get edit_status_update_path(first_status_update)
    new_text = 'Some day you will be old enough to start reading fairy tales again.'
    put status_update_path(first_status_update), params: { status_update: { text: new_text } }

    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_match new_text, response.body
  end

  test 'status update creation sends notification' do
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    text = 'It takes courage to grow up and become who you really are.'
    assert_performed_jobs 1 do
      write_status_update(text)
    end
    @user.friends.each do |friend|
      assert_equal 1, friend.notifications.count
    end
  end

  test 'no edit/delete buttons if user not author' do
    log_in_as @user

    get user_path(users(:ronny))
    assert_select 'div[class = \'ui fluid card commentable lazy_image\']' do
      assert_select 'a', text: 'Delete', count: 0
      assert_select 'a', text: 'Edit', count: 0
    end

    get user_path(@user)
    assert_select 'div[class = \'ui fluid card commentable lazy_image\']', count: 6 do
      assert_select 'a', text: 'Delete', count: 6
      assert_select 'a', text: 'Edit', count: 6
    end
  end

  test 'status update layout' do
    log_in_as @user

    get status_update_path(status_updates :first)
    assert_select 'div[class = \'ui fluid card commentable lazy_image\']', count: 1 do
      assert_select 'img[src=?]', @user.avatar.url(:thumb), count: 1
      assert_select 'a[href=?]', user_path(@user), count: 2
      assert_select 'div.meta.time', text: 'less than a minute ago', count: 1
      assert_select 'div.description', text: 'You only live once, but if you do it right, once is enough.', count: 1
      assert_select 'img[data-src=?]', '/uploads/status_update/309456473/image/normal_haha.jpg'
      assert_select 'a.comments_count', text: '1 comment', count: 1
      assert_select 'span.likes_count', text: '1 like', count: 1
    end
  end

  private

    def write_status_update(text)
      log_in_as @user
      get user_path(@user)
      image = fixture_file_upload('test/fixtures/files/haha.jpg', 'image/jpg')
      post user_status_updates_path(@user), params: { status_update: { text: text,
                                                                       image: image } }
    end
end