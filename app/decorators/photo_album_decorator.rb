class PhotoAlbumDecorator < Draper::Decorator
  delegate_all

  def first_image
    return object.images.first.image.url(:mini) if object.images.exists?
    PhotoAlbum::DEFAULT_IMAGE
  end
end
