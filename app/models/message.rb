# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  body            :text
#  conversation_id :integer
#  user_id         :integer
#  read            :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Message < ApplicationRecord
  # Associations
  belongs_to :conversation
  belongs_to :user

  # Validations
  validates_presence_of :body, :user, :conversation

  # Scopes
  scope :unread, -> { where(read: false) }
  scope :not_sent_by, ->(user) { where.not(user: user) }

  # After commits
  after_create_commit do
    ConversationBroadcastJob.perform_later(id)
  end

  def receiver
    conversation.other_user(user)
  end
end
