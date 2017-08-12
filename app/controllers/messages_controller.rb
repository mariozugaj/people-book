class MessagesController < ApplicationController
  before_action :find_conversation
  before_action :set_conversations, only: :new

  def new
    redirect_to @conversation and return if @conversation
    @message = current_user.messages.build
  end

  def create
    @conversation ||= Conversation.create(sender: current_user,
                                          receiver: @receiver)
    @message = current_user.messages.build(message_params)
    @message.conversation_id = @conversation.id
    @message.save!
    @conversation.touch
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
                        Conversation.between(current_user, @receiver).first
                      else
                        Conversation.find_by_slug(params[:conversation_id])
                      end
    end

    def set_conversations
      @conversations = current_user
                       .conversations
                       .includes({ sender: :profile },
                                 { receiver: :profile },
                                 :messages)
                       .order(updated_at: :desc)
    end
end
