class LikesController < ApplicationController
  include FindPolymorphic

  def index
    @likeable = find_polymorphic(params)
    render partial: 'tooltip', locals: { likeable: @likeable }
  end

  def create
    @likeable = find_polymorphic(params)
    @like = Like.new(likeable: @likeable, user: current_user)
    @like.save
    send_notification(@likeable)
    flash[:success] = 'You liked it!'
  end

  def destroy
    @like = Like.find_by_slug(params[:id])
    authorize @like
    @like.destroy
    flash[:success] = 'You dont\' like it anymore'
  end

  private

    def like_params
      params.permit(:likeable_type, :likeable_id)
    end

    def send_notification(likeable)
      recipient = [likeable.author] unless likeable.author == current_user
      NotificationRelayJob.perform_later(recipient,
                                         current_user,
                                         'liked',
                                         likeable)
    end
end
