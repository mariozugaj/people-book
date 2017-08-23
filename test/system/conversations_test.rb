require 'application_system_test_case'

class ConversationsTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  setup do
    @user = users :maymie
    @friend = users :ronny
    @conversation = conversations :first
    @message = 'Logic will get you from A to Z; imagination will get you everywhere.'
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    RedisTest.start
    RedisTest.configure(:default)
  end

  teardown do
    RedisTest.clear
    RedisTest.stop
  end

  test 'message gets broadcasted and displayed' do
    log_in_as @user
    assert_selector '#navbar_message_count', text: '1'
    click_link 'navbar_message_count'
    assert_selector 'span.ui.red.empty.circular.label'
    click_link "conversation-#{@conversation.slug}"

    within "#conversation-#{@conversation.slug}" do
      refute_selector 'span.ui.red.empty.circular.label'
    end

    fill_in 'message[body]', with: @message
    click_button 'Send'

    assert_text @message
    within find("#conversation-#{@conversation.slug}") do
      assert_text @message.truncate(25)
    end

    log_out
    log_in_as @friend
    assert_selector '#navbar_message_count', text: '1'
    click_link 'navbar_message_count'
    click_link "conversation-#{@conversation.slug}"
    assert_text @message
  end
end