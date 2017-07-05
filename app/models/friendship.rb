class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  validates_presence_of :user_id, :friend_id
  validates_uniqueness_of :friend_id,
                          scope: [:user_id],
                          message: 'he already yours is'
  validate :self_friend

  def self_friend
    errors.add :friend, 'to yourself you can\'t be.' if user_id == friend_id
  end
end
