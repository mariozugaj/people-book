# == Schema Information
#
# Table name: images
#
#  id             :integer          not null, primary key
#  description    :string
#  image          :string
#  likes_count    :integer
#  comments_count :integer
#  photo_album_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Image < ApplicationRecord
  # Associations
  belongs_to :photo_album
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :commenters, through: :comments, source: :author
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :users_who_like_it, through: :likes, source: :user
  has_one :author, through: :photo_album

  # Delegations
  delegate :name, to: :author, prefix: true

  # Uploader
  mount_uploader :image, PhotoAlbumImageUploader
end
