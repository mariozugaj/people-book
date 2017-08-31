class ConversationsController < ApplicationController
  before_action :set_conversation, only: %i[new show destroy]
  before_action :set_conversations, only: %i[index new show]

  def index
    @quote = JSON.parse(File.read(Rails.root.join('public/quotes.json'))).sample
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    redirect_to @conversation and return if @conversation
    conversation = Conversation.new(sender: current_user, receiver: @receiver)
    authorize conversation
    @message = current_user.messages.build
  end

  def show
    authorize @conversation
    Message.update_unread(current_user, @conversation)
    @message = Message.new
  end

  def destroy
    authorize @conversation
    @conversation.destroy
    flash[:success] = 'Conversation destroyed'
    redirect_to conversations_path
  end

  def unread_count
    render json: current_user.unread_conversations_count
  end

  private

    def set_conversation
      @receiver = User.find_by_slug(params[:receiver_id]) if params[:receiver_id]
      @conversation = if @receiver
                        current_user.conversations.with(@receiver).first
                      else
                        Conversation.find_by_slug(params[:id])
                      end
    end

    def set_conversations
      @conversations =
        current_user
        .conversations
        .includes({ sender: :profile },
                  { receiver: :profile },
                  :messages)
        .ordered
    end
end
