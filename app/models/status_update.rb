# == Schema Information
#
# Table name: status_updates
#
#  id             :integer          not null, primary key
#  author_id      :integer
#  text           :text
#  likes_count    :integer
#  comments_count :integer
#  image          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class StatusUpdate < ApplicationRecord

  # Mount image uploader
  mount_uploader :image, StatusImageUploader

  # Associations
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :commenters, through: :comments, source: :author
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :users_who_like_it, through: :likes, source: :user

  # Validations
  validates_presence_of :author_id
  validates :text, length: { maximum: 4000, minimum: 1 }
  validate :text_or_image

  private

  def text_or_image
    if text.nil? && image.nil?
      errors.add 'Please enter either some text or image or both.'
    end
  end
end
