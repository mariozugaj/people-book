# frozen_string_literal: true

class PhotoAlbumPolicy
  attr_reader :user, :photo_album

  def initialize(user, photo_album)
    @user = user
    @photo_album = photo_album
  end

  def create?
    owner?
  end

  def edit?
    owner?
  end

  def update?
    owner?
  end

  def destroy?
    owner?
  end

  def default?
    photo_album.name == 'Cover photos' || photo_album.name == 'Avatars'
  end

  private

  def owner?
    user == photo_album.author
  end
end
