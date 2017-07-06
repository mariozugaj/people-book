class StatusUpdatesController < ApplicationController
  def show
    @status_update = StatusUpdate.find(params[:id])
  end

  def create
    @status_update = current_user.status_updates.build(status_update_params)
    authorize @status_update
    if @status_update.save
      flash[:success] = 'You\'ve posted an update.'
      redirect_back(fallback_location: current_user)
    else
      flash[:alert] = 'We were unable to save your post.'
      redirect_back(fallback_location: current_user)
    end
  end

  private

  def status_update_params
    params.require(:status_update).permit(:text,
                                          image_attachment_attributes: [:data])
  end
end
