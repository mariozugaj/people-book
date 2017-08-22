require 'application_system_test_case'

class NotificationsTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  setup do
    @user = users :maymie
    @friend = users :ronny
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
  end

  test 'notifications ajax pulled on page load' do
    log_in_as @user

    within 'div#notifications' do
      find('i.bell.icon').click
      within 'div.menu' do
        assert_text 'No new notifications'
      end
    end

    visit user_path(@friend)
    within all('.commentable')[6] do
      find(:css, 'i.like.icon').click
    end
    log_out

    log_in_as(@friend)
    within 'div#notifications' do
      assert_selector 'div[class = \'ui right pointing label red\']', text: '1'
      find('i.bell.icon').click
      assert_selector 'div[class = \'ui right pointing label\']', text: '0'
      within 'div.items' do
        assert_text 'Maymie Blick'
        assert_text 'less than a minute ago'
        assert_text 'liked your status update'
        assert_selector 'span[class = \'ui red empty circular label\']'
      end
    end
  end

  test 'clearing all notifications' do
    log_in_as @user

    visit user_path(@friend)
    all(:css, 'i.like.icon').each do |icon|
      icon.click
    end
    log_out

    log_in_as @friend
    within 'div#notifications' do
      assert_selector 'div[class = \'ui right pointing label red\']', text: '11'
      find('i.bell.icon').click
      within 'div.menu' do
        assert :link, text: 'See all'
        click_link 'See all'
      end
    end
    assert_current_path notifications_path
    click_link 'Clear all notifications'
    page.driver.browser.switch_to.alert.accept
    assert_text 'No new notifications'
    assert_text 'Notifications cleared'
  end
end
