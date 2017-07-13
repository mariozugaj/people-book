class PhotoAlbumsController < ApplicationController
  before_action :set_author, only: %i[index show create update ]
  before_action :set_photo_album, only: %i[show edit update destroy]

  def index
    @photo_albums = @author.photo_albums.decorate
  end

  def show; end

  def new
    @photo_album = PhotoAlbum.new
  end

  def edit
    authorize @photo_album
  end

  def create
    @photo_album = @author.photo_albums.build(photo_album_params)
    authorize @photo_album
    if @photo_album.save
      if params[:images]
        send_notification(@author, @photo_album)
        params[:images][:image].each do |image|
          @photo_album.images.create(image: image)
        end
      end
      redirect_to user_photo_album_path(@author, @photo_album), success: 'Photo album was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @photo_album
    if @photo_album.update(photo_album_params)
      if params[:images]
        send_notification(@author, @photo_album)
        params[:images][:image].each do |image|
          @photo_album.images.create(image: image)
        end
      elsif params[:cloud_image]
        Image.create(remote_image_url: params[:cloud_image][:remote_image_url],
                     photo_album: @photo_album)
      end
      redirect_to user_photo_album_path(@author, @photo_album), success: 'Photo album was successfully updated.'
    else
      flash[:alert] = 'There was a problem updating your photo album. Try again?'
      render :edit
    end
  end

  def destroy
    authorize @photo_album
    @photo_album.destroy
    redirect_to user_photo_albums_url, success: 'Photo album was successfully destroyed.'
  end

  private

  def send_notification(author, photo_album)
    recipients = author.friends
    recipients.each do |user|
      Notification.create!(recipient: user,
                           actor: current_user,
                           action: 'shared',
                           notifiable: photo_album)
    end
  end

  def set_photo_album
    @photo_album = PhotoAlbum.find(params[:id])
  end

  def photo_album_params
    params.require(:photo_album).permit(:author_id,
                                        :name,
                                        :description,
                                        images_attributes:
                                          %i[id
                                             photo_album_id
                                             image],
                                        cloud_image_attributes:
                                          %i[id
                                             photo_album_id
                                             remote_image_url])
  end

  def set_author
    @author = User.find(params[:user_id])
  end
end
