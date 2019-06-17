# frozen_string_literal: true

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
#  slug            :string           not null
#

class Message < ApplicationRecord
  include Slug

  # Associations
  belongs_to :conversation, touch: true
  belongs_to :user

  # Validations
  validates_presence_of :body, :user, :conversation

  # Scopes
  default_scope { order(created_at: :asc) }
  scope :unread, -> { where(read: false) }
  scope :not_sent_by, ->(user) { where.not(user: user) }

  # After commits
  after_create_commit do
    ConversationBroadcastJob.perform_later(slug)
  end

  # Delegations
  delegate :name, to: :user, prefix: true

  def receiver
    conversation.other_user(user)
  end

  def self.update_unread(user, conversation)
    where(conversation: conversation)
      .not_sent_by(user)
      .unread
      .update_all(read: true)
  end
end
