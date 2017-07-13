class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[set_avatar set_cover edit update]
  before_action :set_image, only: %i[set_avatar set_cover]

  def edit
    authorize @profile
    @relationship_options = Profile::RELATIONSHIP_OPTIONS
  end

  def update
    authorize @profile
    if @profile.update(profile_params)

      # Send notifications
      recipients = @profile.user.friends
      recipients.each do |user|
        Notification.create(recipient: user,
                            actor: current_user,
                            action: 'updated',
                            notifiable: @profile)
      end

      flash[:success] = 'You\'ve successfuly updated your profile'
      redirect_to current_user
    else
      flash[:alert] = 'Something went wrong. Try again?'
      render :edit
    end
  end

  def set_avatar
    @profile.remove_avatar = true
    @profile.save
    if @profile.update(avatar: @image.image)
      flash[:success] = 'You\'ve successfuly updated your avatar'
      redirect_to current_user
    end
  end

  def set_cover
    @profile.remove_cover_photo = true
    @profile.save
    if @profile.update(cover_photo: @image.image)
      flash[:success] = 'You\'ve successfuly updated your cover photo'
      redirect_to current_user
    end
  end

  private

  def set_profile
    @user = User.find(params[:user_id])
    @profile = @user.profile
  end

  def set_image
    @image = Image.find(params[:image_id])
  end

  def profile_params
    params.require(:profile).permit(:user_id, :birthday, :education, :hometown,
                                    :profession, :company, :relationship_status,
                                    :about, :phone_number, :avatar, :cover_photo)
  end
end
