# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_type :string
#  commentable_id   :integer
#  author_id        :integer
#  text             :text
#  likes_count      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Comment < ApplicationRecord
  # Associations
  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :users_who_like_it, through: :likes, source: :user
  has_many :notifications, as: :notifiable, dependent: :destroy

  # Validations
  validates_presence_of :author, :commentable_id, :commentable_type
  validates :text, length: { maximum: 4000, minimum: 1 }

  # Scopes
  default_scope { order(created_at: :asc) }
end
