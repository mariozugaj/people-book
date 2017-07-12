class PhotoAlbumDecorator < Draper::Decorator
  delegate_all

  def first_image
    return object.images.first.image.url(:mini) if object.images.any?
    PhotoAlbum::DEFAULT_IMAGE
  end
end
