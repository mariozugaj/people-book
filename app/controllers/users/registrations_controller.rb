# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      CompleteRegistration.execute(resource) if resource.persisted?
    end
  end
end
