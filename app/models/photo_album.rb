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
#

class PhotoAlbum < ApplicationRecord

  # Associations
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  # Validations
  validates_presence_of :name, :author

  DEFAULT_IMAGE = ''
end
