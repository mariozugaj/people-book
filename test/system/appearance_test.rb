require 'application_system_test_case'

class AppearanceTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  setup do
    @user = users :maymie
    @friend = users :ronny
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
  end

  test 'appearance indicator changes on login/logout' do
    in_browser(:one) do
      log_in_as @user
      visit conversations_path
      assert_selector "span.ui.empty.circular.label.user-#{@friend.slug}"
    end

    in_browser(:two) do
      log_in_as @friend
      visit conversations_path
      assert_selector "span.ui.empty.circular.label.user-#{@user.slug}.green"
    end

    in_browser(:one) do
      assert_selector "span.ui.empty.circular.label.user-#{@friend.slug}.green"
      log_out
    end

    in_browser(:two) do
      assert_selector "span.ui.empty.circular.label.user-#{@user.slug}"
    end
  end
end