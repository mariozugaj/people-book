class PhotoAlbumsController < ApplicationController
  before_action :set_photo_album, only: %i[show edit update destroy]

  def index
    @user = User.find_by_slug(params[:user_id])
    @photo_albums = @user.photo_albums.includes(:images)
  end

  def show; end

  def new
    @photo_album = PhotoAlbum.new
  end

  def edit
    authorize @photo_album
  end

  def create
    @photo_album = current_user.photo_albums.build(photo_album_params)
    authorize @photo_album
    if @photo_album.save
      UploadPhotoAlbumImages.execute(@photo_album, params)
      flash[:success] = 'Photo album was successfully created.'
      redirect_to user_photo_album_path(current_user, @photo_album)
    else
      render :new
    end
  end

  def update
    authorize @photo_album
    if @photo_album.update(photo_album_params)
      UploadPhotoAlbumImages.execute(@photo_album, params)
      flash[:success] = 'Photo album was successfully updated.'
      redirect_to user_photo_album_path(current_user, @photo_album)
    else
      flash[:alert] = 'There was a problem updating your photo album. Try again?'
      render :edit
    end
  end

  def destroy
    authorize @photo_album
    if @photo_album.destroy
      flash[:success] = 'Photo album was successfully destroyed.'
      redirect_to user_photo_albums_path
    else
      flash[:notice] = 'There was a problem destroying the photo album.'
      render :edit
    end
  end

  private

    def set_photo_album
      @photo_album = PhotoAlbum.includes(:images).find_by_slug(params[:id])
    end

    def photo_album_params
      params.require(:photo_album)
            .permit(:author_id,
                    :name,
                    :description,
                    images_attributes: %i[id image],
                    cloud_image_attributes: %i[id remote_image_url])
    end
end
