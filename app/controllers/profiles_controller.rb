class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[edit update]

  def edit
    authorize @profile
    @relationship_options = Profile::RELATIONSHIP_OPTIONS
  end

  def update
    authorize @profile
    if @profile.update(profile_params)
      flash[:success] = 'You\'ve successfuly updated your profile'
      redirect_to current_user
    else
      flash[:alert] = 'Something went wrong. Try again?'
      render :edit
    end
  end

  private

  def set_profile
    @user = User.find(params[:user_id])
    @profile = @user.profile
  end

  def profile_params
    params.require(:profile).permit(:user_id, :birthday, :education, :hometown,
                                    :profession, :company, :relationship_status,
                                    :about, :phone_number, :avatar, :cover_photo)
  end
end
