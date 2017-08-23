class ConversationsController < ApplicationController
  before_action :set_conversation, only: :show
  before_action :set_conversations, only: %i[index show]
  before_action :check_participating!, only: :show

  def index
    @quote = JSON.parse(File.read(Rails.root.join('public/quotes.json'))).sample
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @message = Message.new
    @conversation.messages.not_sent_by(current_user).unread.update_all(read: true)
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

    def check_participating!
      redirect_to root_path unless @conversation && @conversation.participates?(current_user)
    end

    def set_conversation
      @conversation = Conversation.includes(messages: [user: :profile])
                                  .find_by_slug(params[:id])
    end

    def set_conversations
      @conversations = current_user
                       .conversations
                       .includes({ sender: :profile },
                                 { receiver: :profile },
                                 :messages)
                       .ordered
    end
end
