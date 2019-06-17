# frozen_string_literal: true

class CompleteRegistration
  def initialize(user, avatar = nil)
    @user = user
    @avatar = avatar
  end

  def self.execute(*args)
    new(*args).execute
  end

  def execute
    create_profile
    create_photo_albums
    send_welcome_email
  end

  def create_profile
    Profile.create(user: user, remote_avatar_url: avatar)
  end

  def create_photo_albums
    PhotoAlbum.create(author: user, name: 'Avatars')
    PhotoAlbum.create(author: user, name: 'Cover photos')
  end

  def send_welcome_email
    UserMailer.welcome(user).deliver_later
  end

  private

  attr_reader :user, :avatar
end
