require 'test_helper'

class ConversationInterfaceTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @user = users :maymie
    @friend_no_c = users :kassandra
    @friend_c = users :ronny
    @not_friend = users :antonina
    @conversation = conversations :first
    @message = 'Logic will get you from A to Z; imagination will get you everywhere.'
  end

  test 'conversation layout' do
    log_in_as @user

    get conversations_path
    assert_select "h3[class = 'ui header']", text: 'Conversations'
    assert_select 'input.prompt', placeholder: 'Search friends to speak with'
    assert_select "a[class = 'item conversation']", count: 1
    assert_select 'span.header', text: @friend_c.name
    assert_select 'div.description', text: messages(:second).body.truncate(25)
    assert_select 'span.date', text: 'less than a minute ago'
    assert_select "h2[class = 'ui center aligned icon header']"
    assert_select "i[class = 'comments outline icon']"

    get conversation_path(@conversation)
    assert_select "a[class = 'ui blue button']", text: @friend_c.name
    assert_select "span[class = 'ui empty circular label user-#{@friend_c.slug}']", count: 2
    assert_select "form[action = '/messages.js']"
    assert_select "a[href = 'https://www.webpagefx.com/tools/emoji-cheat-sheet/']", text: 'Emoji cheat sheet'
  end

  test 'can start conversation with a friend' do
    log_in_as @user

    get user_path(@friend_no_c)
    assert_select 'a', text: 'Send message'
    get new_conversation_path, params: { receiver_id: @friend_no_c.slug }
    assert_response :success
  end

  test 'cannot start conversation if not a friend' do
    log_in_as @user

    get user_path(@not_friend)
    assert_select 'a', text: 'Send message', count: 0
    get new_conversation_path, params: { receiver_id: @not_friend.slug }
    assert_response :redirect
    follow_redirect!
    assert_equal 'Akward! Seems like you wanted to do something you are not allowed to.', flash[:alert]
  end

  test 'creates a new conversation if it does not exist' do
    log_in_as @user

    get user_path(@friend_no_c)
    get new_conversation_path, params: { receiver_id: @friend_no_c.slug }
    post messages_path, params: { receiver_id: @friend_no_c.slug,
                                  message: { body: @message } }
    assert_response :redirect
    follow_redirect!
    assert_select 'div.text', text: @message, count: 1
    assert_select 'div.description', text: @message.truncate(25), count: 1
  end

  test 'message gets sent' do
    log_in_as @user

    get conversation_path(@conversation)
    assert_difference 'Message.count', 1 do
      post messages_path, params: { conversation_id: @conversation.slug,
                                    message: { body: @message } }
    end
  end

  test 'can delete conversation if participating' do
    log_in_as @user

    get conversation_path(@conversation)
    assert_select 'i[class = \'wrench icon\']'
    assert_select 'a.item', text: 'Delete conversation'
    assert_difference 'Conversation.count', -1 do
      delete conversation_path(@conversation)
    end
    assert_response :redirect
    assert_redirected_to conversations_path
    follow_redirect!
    assert_equal 'Conversation destroyed', flash[:success]
    assert_select 'h4', text: 'No conversations. Start a new one?'
  end

  test 'cannot show conversation if not participating' do
    log_in_as @not_friend

    get conversation_path(@conversation)
    assert_redirected_to home_path
    follow_redirect!
    assert_equal 'Akward! Seems like you wanted to do something you are not allowed to.', flash[:alert]
  end

  test 'cannot delete conversation if not participating' do
    log_in_as @not_friend
    assert_no_difference 'Conversation.count' do
      delete conversation_path(@conversation)
    end
  end

  test 'message gets broadcasted' do
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
    log_in_as @user

    get user_path(@friend_no_c)
    get new_conversation_path(receiver_id: @friend_no_c.slug)
    assert_performed_jobs 1 do
      post messages_path, params: { receiver_id: @friend_no_c.slug,
                                    message: { body: @message } }
    end
  end
end
