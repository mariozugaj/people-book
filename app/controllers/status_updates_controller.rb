class StatusUpdatesController < ApplicationController

  before_action :set_status_update, only: %i[show edit update destroy]

  def show; end

  def create
    @status_update = current_user.status_updates.build(status_update_params)
    authorize @status_update
    if @status_update.save
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
    @status_update = StatusUpdate.find(params[:id])
  end

  def status_update_params
    params.require(:status_update).permit(:text, :image)
  end
end
