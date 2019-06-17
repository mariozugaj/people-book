# frozen_string_literal: true

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  def setup
    @message = messages(:first)
    @user = @message.user
    @conversation = @message.conversation
  end

  test 'should be valid' do
    assert @message.valid?
  end

  test 'not sent by' do
    other_messsage = @conversation.messages.not_sent_by(@user).first
    assert_equal messages(:second), other_messsage
  end

  test 'update unread messages' do
    unread_messsage = messages :second
    Message.update_unread(@user, @conversation)
    assert unread_messsage.reload.read?
  end

  test 'messages broadcast job gets enqueued' do
    assert_enqueued_jobs 1 do
      Message.create!(
        user: users(:maymie),
        body: 'Insanity is doing the same thing, over and over'\
              'again, but expecting different results.',
        conversation: conversations(:first)
      )
    end
  end
end
