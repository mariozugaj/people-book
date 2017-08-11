class ConversationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    message = Message.find(message_id)
    ActionCable.server
               .broadcast "conversations:#{message.user.id}",
                          message: render_message(message),
                          conversation_id: message.conversation_id,
                          unread_count: message.user.unread_conversations_count
  end

  private

    def render_message(message)
      MessagesController.render partial: 'messages/message',
                                locals: { message: message }
    end
end
