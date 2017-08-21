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

  test 'messages broadcast job gets enqueued' do
    assert_enqueued_with(job: ConversationBroadcastJob,
                         args: [@message.slug],
                         queue: 'default') do
      @message.save
    end
  end
end
