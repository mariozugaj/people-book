# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      CompleteRegistration.execute(@user, request.env['omniauth.auth'].info.image) if @user.profile.nil?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    else
      flash[:notice] = "Sorry, we couldn't log you in through Facebook."
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_path
    end
  end

  def failure
    flash[:notice] = "Sorry, we couldn't log you in through Facebook."
    redirect_to new_user_registration_path
  end
end
