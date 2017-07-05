class Profile < ApplicationRecord
  belongs_to :user, inverse_of: :profile
  has_one :avatar, as: :imageable,
                   class_name: 'ImageAttachment',
                   dependent: :destroy
  has_one :cover_photo, as: :imageable,
                        class_name: 'ImageAttachment',
                        dependent: :destroy

  validates_presence_of :user
end
