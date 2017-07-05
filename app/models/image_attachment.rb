class ImageAttachment < ApplicationRecord
  PAPERCLIP_IMAGE_SIZE_LIMIT = 10
  PAPERCLIP_IMAGE_CONTENT_TYPE = 'image/jpeg'.freeze

  belongs_to :imageable, polymorphic: true

  has_attached_file :data,
                    styles:          { avatar: '300x300', cover: '1200x500', post: '800x400' },
                    convert_options: { avatar: '-quality 75 -strip', cover: '-quality 90 -strip' }
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates_attachment_presence     :data
  validates_attachment_size         :data, less_than:    PAPERCLIP_IMAGE_SIZE_LIMIT
  validates_attachment_content_type :data, content_type: PAPERCLIP_IMAGE_CONTENT_TYPE

  # Conditional Uniqueness validation on the belongs_to scope
  validates :default, uniqueness: { scope: :imageable }, if: :default?

  # Methods to set/unset the default image
  def undefault!
    update(default: false)
  end

  def default!
    imageable.default_image.undefault! if imageable.default_image
    update(default: true)
  end

  def avatar_remote_url=(url_value)
    self.data = URI.parse(url_value)
    @data_remote_url = url_value
  end
end
