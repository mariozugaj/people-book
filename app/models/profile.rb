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
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

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
