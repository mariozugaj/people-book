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
  has_many :likers, through: :likes, source: :user
  has_one :author, through: :photo_album

  # Delegations
  delegate :name, to: :author, prefix: true

  # Search
  searchkick text_middle: %i[description]
  scope :search_import, -> { includes(author: :profile) }

  # Uploader
  mount_uploader :image, PhotoAlbumImageUploader

  def search_info
    {
      title: description,
      image: image.url(:thumb) || '',
      url: Rails.application.routes.url_helpers.image_path(self),
      description: author_name
    }
  end
end
