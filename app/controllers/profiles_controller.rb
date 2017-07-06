class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[update edit]

  RELATIONSHIP_OPTIONS = ['Single',
                          'In a relationship',
                          'Engaged',
                          'Married',
                          'In a civil partnership',
                          'In a domestic partnership',
                          'In an open relationship',
                          'It\'s complicated',
                          'Separated',
                          'Divorced',
                          'Widowed']

  def edit
    @user = User.find(params[:user_id])
    @relationship_options = RELATIONSHIP_OPTIONS
  end

  def update
    if @profile.update_attributes(profile_params)
      flash[:success] = 'You\'ve successfuly updated your profile'
      redirect_to current_user
    else
      flash[:alert] = 'Something went wrong. Try again?'
      render :edit
    end
  end

  private

  def set_profile
    @profile = current_user.profile
  end

  def profile_params
    params.require(:profile).permit(:user_id, :birthday, :education, :hometown,
                                    :profession, :company, :relationship_status,
                                    :about, :phone_number, :avatar, :cover_photo)
  end
end
