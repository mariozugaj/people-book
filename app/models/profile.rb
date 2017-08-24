# == Schema Information
#
# Table name: profiles
#
#  id                  :integer          not null, primary key
#  user_id             :integer          not null
#  birthday            :date
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
  validates :about, length: { maximum: 150 }
  validates :education, :hometown, :phone_number, length: { maximum: 75 }
  validates :profession, :company, length: { maximum: 35 }
  validate :minimum_age

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
    ((Date.today - birthday) / 365.2422).to_i
  end

  private

    def minimum_age
      if birthday.present? && birthday > 13.years.ago
        errors.add(:birthday, "can't be less than 13 years")
      end
    end
end
