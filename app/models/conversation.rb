# == Schema Information
#
# Table name: conversations
#
#  id          :integer          not null, primary key
#  sender_id   :integer
#  receiver_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string
#

class Conversation < ApplicationRecord
  # Associations
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_many :messages,
           dependent: :destroy

  # Validations
  validates :sender, uniqueness: { scope: :receiver }

  # Scopes
  scope :with_user, ->(user) do
    unscope(:where).where('? IN (sender_id, receiver_id)', user.id)
  end

  scope :between, ->(user1, user2) do
    where('sender_id IN (:ids) AND receiver_id IN (:ids)', ids: [user1.id, user2.id])
  end

  scope :ordered, -> { order(created_at: :desc) }

  # Slug
  include Slug

  def other_user(current_user)
    sender == current_user ? receiver : sender
  end

  def participates?(user)
    sender == user || receiver == user
  end
end
