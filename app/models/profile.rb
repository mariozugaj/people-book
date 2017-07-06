# == Schema Information
#
# Table name: profiles
#
#  id                  :integer          not null, primary key
#  user_id             :integer          not null
#  birthday            :datetime
#  education           :string
#  hometown            :string
#  profession          :string
#  company             :string
#  relationship_status :string
#  about               :string
#  phone_number        :string
#  avatar              :string
#  cover_photo         :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Profile < ApplicationRecord

  # Mount avatar and cover photo uploader
  mount_uploader :avatar, AvatarUploader
  mount_uploader :cover_photo, CoverPhotoUploader

  # Associaitons
  belongs_to :user, inverse_of: :profile

  # Validations
  validates_presence_of :user
end
