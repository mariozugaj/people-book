class UploadPhotoAlbumImages
  def initialize(photo_album, params)
    @photo_album = photo_album
    @params = params
  end

  def self.execute(*args)
    new(*args).execute
  end

  def execute
    upload_images unless params[:images].blank?
    upload_cloud_image unless params[:cloud_image][:remote_image_url].blank?
    send_notification
  end

  def upload_images
    params[:images][:image].each do |image|
      photo_album.images.create(image: image)
    end
  end

  def upload_cloud_image
    Image.create(remote_image_url: params[:cloud_image][:remote_image_url],
                 photo_album: photo_album)
  end

  def send_notification
    recipients = photo_album.author.friends
    recipients.each do |user|
      Notification.create!(recipient: user,
                           actor: photo_album.author,
                           action: 'shared',
                           notifiable: photo_album)
    end
  end

  private

    attr_reader :photo_album, :params
end
