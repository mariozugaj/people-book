class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, counter_cache: true
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  has_many :likes, as: :likeable, dependent: :destroy

  validates_presence_of :author, :commentable_id, :commentable_type
end
