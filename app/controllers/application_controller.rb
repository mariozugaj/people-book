class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Pundit

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :set_notifications, if: :user_signed_in?

  def set_notifications
    @notifications = Notification.includes(:actor, :notifiable).where(recipient: current_user).recent
  end
  private

  def user_not_authorized
    flash[:alert] = "Akward! Seems like you wanted to go somewhere you are not allowed to."
    redirect_to(request.referrer || root_path)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
