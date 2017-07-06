class StatusUpdate < ApplicationRecord

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_one :image_attachment, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :image_attachment

  validates_presence_of :author_id
  validate :text_or_image

  private

  def text_or_image
    if text.nil? && image_attachment.nil?
      errors.add 'Please enter either some text or image or both.'
    end
  end
end
