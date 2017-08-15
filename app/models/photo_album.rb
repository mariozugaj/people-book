# == Schema Information
#
# Table name: photo_albums
#
#  id          :integer          not null, primary key
#  author_id   :integer
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string
#

class PhotoAlbum < ApplicationRecord

  # Associations
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :images, dependent: :destroy
  has_one :cloud_image, class_name: 'Image', dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true
  accepts_nested_attributes_for :cloud_image, allow_destroy: true

  # Validations
  validates_presence_of :name, :author

  # Default photo album image
  DEFAULT_IMAGE = 'https://s3.eu-central-1.amazonaws.com/chanjman-peoplebook/missing/photo_album/missing.jpg'

  # Slug
  include Slug

  def first_image
    return images.first.image.url(:mini) if images.exists?
    PhotoAlbum::DEFAULT_IMAGE
  end
end
