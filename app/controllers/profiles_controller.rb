class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[set_avatar set_cover edit]
  before_action :set_image, only: %i[set_avatar set_cover]

  def edit
    authorize @profile
    @relationship_options = Profile::RELATIONSHIP_OPTIONS
  end

  def update
    @relationship_options = Profile::RELATIONSHIP_OPTIONS
    @profile = Profile.find_by_slug(params[:profile_id])
    authorize @profile
    if @profile.update(profile_params)
      send_notification(@profile)
      flash[:success] = 'You\'ve successfuly updated your profile'
      redirect_to current_user
    else
      flash[:alert] = 'There was a problem updating your profile. Try again?'
      render :edit
    end
  end

  def set_avatar
    authorize @profile
    @profile.remove_avatar = true
    @profile.save
    if @profile.update(avatar: @image.image)
      send_notification(@profile)
      flash[:success] = 'You\'ve successfuly updated your avatar'
      redirect_to current_user
    end
  end

  def set_cover
    authorize @profile
    @profile.remove_cover_photo = true
    @profile.save
    if @profile.update(cover_photo: @image.image)
      send_notification(@profile)
      flash[:success] = 'You\'ve successfuly updated your cover photo'
      redirect_to current_user
    end
  end

  private

  def set_profile
    @user = User.find_by_slug(params[:user_id])
    @profile = @user.profile
  end

  def set_image
    @image = Image.find_by_slug(params[:image_id])
  end

  def profile_params
    params.require(:profile).permit(:user_id, :birthday, :education, :hometown,
                                    :profession, :company, :relationship_status,
                                    :about, :phone_number, :avatar, :cover_photo)
  end

  def send_notification(profile)
    NotificationRelayJob.perform_later(
      profile.user.friends.to_a,
      current_user,
      'updated',
      profile
    )
  end
end
