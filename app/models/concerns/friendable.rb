module Friendable
  extend ActiveSupport::Concern

  included do
    has_many :friendships, dependent: :destroy
    has_many :friends,
             -> { where friendships: { status: 2 } },
             through: :friendships
    has_many :requested_friends,
             -> { where friendships: { status: 1 } },
             through: :friendships,
             source: :friend
    has_many :pending_friends,
             -> { where friendships: { status: 0 } },
             through: :friendships,
             source: :friend
  end

  def friend_request(friend)
    unless self == friend || Friendship.exist?(self, friend)
      transaction do
        Friendship.create_relation(self, friend, status: 0)
        Friendship.create_relation(friend, self, status: 1)
      end
    end
  end

  def accept_request(friend)
    on_relation_with(friend) do |one, other|
      friendship = Friendship.find_relation(one, other).first
      friendship.accept! if can_accept_request?(friendship)
    end
  end

  def decline_request(friend)
    on_relation_with(friend) do |one, other|
      Friendship.find_relation(one, other).first.destroy
    end
  end

  alias_method :remove_friend, :decline_request

  def on_relation_with(friend)
    transaction do
      yield(self, friend)
      yield(friend, self)
    end
  end

  def friends_with?(friend)
    Friendship.find_relation(self, friend, status: 2).any?
  end

  private
    def can_accept_request?(friendship)
      return if friendship.pending? && self == friendship.user
      return if friendship.requested? && self == friendship.friend

      true
    end
end
