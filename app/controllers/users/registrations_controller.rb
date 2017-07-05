class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      Profile.create!(user: resource)
    end
  end
end
