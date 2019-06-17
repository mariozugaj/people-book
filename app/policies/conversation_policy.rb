# frozen_string_literal: true

class ConversationPolicy
  attr_reader :user, :conversation

  def initialize(user, conversation)
    @user = user
    @conversation = conversation
  end

  def show?
    participates?
  end

  def new?
    friend?
  end

  def destroy?
    participates?
  end

  private

  def friend?
    user.friends_with? conversation.receiver
  end

  def participates?
    conversation.participates? user
  end
end
