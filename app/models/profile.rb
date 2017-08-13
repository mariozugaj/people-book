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
#  slug                :string
#

class Profile < ApplicationRecord

  # Mount avatar and cover photo uploader
  mount_uploader :avatar, AvatarUploader
  mount_uploader :cover_photo, CoverPhotoUploader

  # Associaitons
  belongs_to :user, inverse_of: :profile

  # Validations
  validates_presence_of :user

  # Slug
  include Slug

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

  # Calculate user's age
  def age
    ((Time.zone.now - birthday) / (365.2422 * 60 * 60 * 24)).to_i
  end
end
