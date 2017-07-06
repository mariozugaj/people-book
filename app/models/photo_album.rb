# == Schema Information
#
# Table name: photo_albums
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PhotoAlbum < ApplicationRecord

  # Associations
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  has_many :images, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :images

  #Validations
  validates_presence_of :name
end
