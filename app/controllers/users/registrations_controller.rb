class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.persisted?
        CompleteRegistration.execute(resource)
      end
    end
  end
end
