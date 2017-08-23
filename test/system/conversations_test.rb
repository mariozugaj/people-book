require 'application_system_test_case'

class ConversationsTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  setup do
    @user = users :maymie
    @friend = users :ronny
    @conversation = conversations :first
    @message1 = 'Logic will get you from A to Z; imagination will get you everywhere.'
    @message2 = 'Life is far too important a thing ever to talk seriously about.'
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    RedisTest.start
    RedisTest.configure(:default)
  end

  teardown do
    RedisTest.clear
    RedisTest.stop
  end

  test 'message gets broadcasted and displayed' do
    in_browser(:one) do
      log_in_as @user
      assert_selector '#navbar_message_count', text: '1'
      click_link 'navbar_message_count'
      assert_selector 'span.ui.red.empty.circular.label'
      click_link "conversation-#{@conversation.slug}"

      within "#conversation-#{@conversation.slug}" do
        refute_selector 'span.ui.red.empty.circular.label'
      end

      fill_in 'message[body]', with: @message1
      click_button 'Send'

      assert_text @message1
      within find("#conversation-#{@conversation.slug}") do
        assert_text @message1.truncate(25)
      end
    end

    in_browser(:two) do
      log_in_as @friend
      assert_selector '#navbar_message_count', text: '1'
      click_link 'navbar_message_count'
      click_link "conversation-#{@conversation.slug}"
      assert_text @message1
      fill_in 'message[body]', with: @message2
      click_button 'Send'
      assert_text @message2
    end

    in_browser(:one) do
      assert_text @message2
    end
  end
end