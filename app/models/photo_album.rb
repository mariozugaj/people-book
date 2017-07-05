class PhotoAlbum < ApplicationRecord
  include Imageable

  belongs_to :author, class_name: 'User', foreign_key: :user_id

  validates_presence_of :name
end
