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
#  slug                :string           not null
#

class Profile < ApplicationRecord
  include Slug

  # Mount avatar and cover photo uploader
  mount_uploader :avatar, AvatarUploader
  mount_uploader :cover_photo, CoverPhotoUploader

  # Associaitons
  belongs_to :user, inverse_of: :profile

  # Validations
  validates :user, presence: true, uniqueness: true

  RELATIONSHIP_OPTIONS = ['Single',
                          'In a relationship',
                          'Engaged',
                          'Married',
                          'In a civil partnership',
                          'In a domestic partnership',
                          'In an open relationship',
                          'It\'s complicated',
                          'Separated',
                          'Divorced',
                          'Widowed'].freeze

  def age
    ((Time.current - birthday) / (365.2422 * 24 * 60 * 60)).to_i
  end
end
