# frozen_string_literal: true

class ConversationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    message = Message.find_by_slug(message_id)
    ActionCable.server
      .broadcast "conversations:#{message.conversation.slug}:messages",
                 message: render_message(message)
  end

  private

  def render_message(message)
    MessagesController.render partial: 'messages/message',
                              locals: { message: message }
  end
end
