class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.persisted?
        Profile.create!(user: resource)
        PhotoAlbum.create!(author: resource, name: 'Avatars')
        PhotoAlbum.create!(author: resource, name: 'Cover photos')
        UserMailer.welcome(resource).deliver_later
      end
    end
  end
end
