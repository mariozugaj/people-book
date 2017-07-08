# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  friend_id  :integer          not null
#  accepted   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Friendship < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  # Validations
  validates_presence_of :user_id, :friend_id
  validates_uniqueness_of :friend_id,
                          scope: [:user_id],
                          message: 'he already yours is'
  validate :self_friend

  private

  def self_friend
    errors.add :friend, 'to yourself you can\'t be.' if user_id == friend_id
  end
end
