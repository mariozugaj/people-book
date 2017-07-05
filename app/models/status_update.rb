class StatusUpdate < ApplicationRecord
  include Imageable

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates_presence_of :author_id
  validate :text_or_picture

  private

  def text_or_picture
    if text.nil? && image.nil?
      errors.add 'Please enter either some text or picture or both.'
    end
  end
end
