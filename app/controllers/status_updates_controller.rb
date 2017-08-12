class StatusUpdatesController < ApplicationController
  before_action :set_status_update, only: %i[edit update destroy]

  def show
    @status_update = StatusUpdate.includes(author: :profile)
                                 .find_by_slug(params[:id])
  end

  def create
    @status_update = StatusUpdate.new(status_update_params)
    authorize @status_update
    if @status_update.save

      # Send notifications
      recipients = @status_update.author.friends
      recipients.each do |user|
        Notification.create(recipient: user,
                            actor: current_user,
                            action: 'posted',
                            notifiable: @status_update)
      end

      flash[:success] = 'You\'ve posted an update.'
    else
      flash[:alert] = 'We were unable to save your post.'
    end
    redirect_to request.referrer || current_user
  end

  def edit
    authorize @status_update
  end

  def update
    authorize @status_update
    if @status_update.update(status_update_params)
      flash[:success] = 'Status successfuly updated'
      redirect_back(fallback_location: current_user)
    else
      flash[:alert] = 'There was a problem updating your status. Try again?'
      render :edit
    end
  end

  def destroy
    authorize @status_update
    if @status_update.destroy
      flash[:success] = 'Your status update was destroyed'
    else
      flash[:alert] = 'There was a problem destroying your status update. Plese try again.'
    end
    redirect_back(fallback_location: current_user)
  end

  private

  def set_status_update
    @status_update = StatusUpdate.find_by_slug(params[:id])
  end

  def status_update_params
    params.require(:status_update).permit(:author_id, :text, :image, :remote_image_url)
  end
end
