class MessagesController < ApplicationController
  before_action :find_conversation

  def create
    message = current_user.messages.build(message_params)
    message.conversation_id = @conversation.id
    message.save!
    respond_to do |format|
      format.html { redirect_to @conversation }
      format.js
    end
  end

  private

    def message_params
      params.require(:message).permit(:body, :conversation_id)
    end

    def find_conversation
      @receiver = User.find_by_slug(params[:receiver_id]) if params[:receiver_id]
      @conversation = if @receiver
                        Conversation.create(sender: current_user, receiver: @receiver)
                      else
                        Conversation.find_by_slug(params[:conversation_id])
                      end
    end
end
