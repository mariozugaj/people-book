# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  friend_id  :integer          not null
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#

class Friendship < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: :friend_id

  # Validations
  validates_presence_of :user_id, :friend_id
  validates_uniqueness_of :friend_id,
                          scope: [:user_id],
                          message: 'he already yours is'

  # Status
  enum status: { pending: 0, requested: 1, accepted: 2 } do
    event :accept do
      transition %i[pending requested] => :accepted
    end
  end

  # Slug
  include Slug

  private

    def self.relation_attributes(one, other, status: nil)
      attr = {
        user_id: one.id,
        friend_id: other.id
      }

      attr[:status] = status if status

      attr
    end

    def self.create_relation(one, other, options)
      relation = new relation_attributes(one, other)
      relation.attributes = options
      relation.save
    end

    def self.find_relation(user, friend, status: nil)
      where relation_attributes(user, friend, status: status)
    end

    def self.exist?(user, friend)
      find_relation(user, friend).any? && find_relation(friend, user).any?
    end
end
