class ConversationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "conversations:#{current_user.id}"
  end

  def unsubscribed
    stop_all_streams
  end
end
