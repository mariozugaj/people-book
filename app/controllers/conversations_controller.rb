class ConversationsController < ApplicationController
  before_action :set_conversation, only: :show
  before_action :set_conversations, only: %i[index show]
  before_action :check_participating!, only: :show

  def index
    @quote = JSON.parse(File.read(Rails.root.join('public/quotes.json'))).sample
  end

  def show
    @message = Message.new
    @conversation.messages.not_sent_by(current_user).unread.update_all(read: true)
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
                                  .find(params[:id])
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
