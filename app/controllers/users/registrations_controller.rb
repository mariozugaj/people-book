class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super
    Profile.create!(user: resource)
    PhotoAlbum.create!(author: resource, name: 'Avatars')
    PhotoAlbum.create!(author: resource, name: 'Cover photos')
  end
end
