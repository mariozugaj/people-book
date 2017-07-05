module Imageable
  extend ActiveSupport::Concern

  included do
    has_many :image_attachments, as: :imageable, dependent: :destroy
    alias_attribute :images, :image_attachments
  end

  def default_image
    images.find_by(default: true) || images.first
  end
end
