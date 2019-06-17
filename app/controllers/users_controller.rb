# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :check_email

  def show
    @user ||= User.includes(:profile).find_by_slug(params[:id])
    @new_status_update = StatusUpdate.new
    @feed = StatusUpdate.includes({ author: :profile }, :likers)
      .where(author: @user)
      .ordered
      .page(params[:page])
  end

  def check_email
    emails = User.pluck(:email)
    response = (emails.include?(params[:email]) ? true : false)
    respond_to do |format|
      format.js { render json: response, status: 200 }
    end
  end
end
