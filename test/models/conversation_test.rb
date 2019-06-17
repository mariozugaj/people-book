# frozen_string_literal: true

require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  def setup
    @user1 = users(:maymie)
    @user2 = users(:ronny)
    @conversation = conversations(:first)
  end

  test 'should be valid' do
    assert @conversation.valid?
  end

  test 'sender and receiver should be present' do
    @conversation.sender, @conversation.receiver = nil
    refute @conversation.valid?
  end

  test 'finds conversation with other user' do
    @conversation.save
    conversation = @user1.conversations.with(@user2).first
    assert_equal conversation, @conversation
  end

  test 'finds other user' do
    other_user1 = @conversation.other_user(@user1)
    other_user2 = @conversation.other_user(@user2)
    assert_equal @user2, other_user1
    assert_equal @user1, other_user2
  end

  test 'user participation' do
    assert @conversation.participates?(@user1)
    assert @conversation.participates?(@user2)
    refute @conversation.participates?(users(:casimir))
  end
end
