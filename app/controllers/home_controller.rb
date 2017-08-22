class HomeController < ApplicationController
  def index
    @new_status_update ||= StatusUpdate.new
    @feed =
      StatusUpdate.includes([{ author: :profile }, :likers])
                  .where("author_id IN (:ids) OR author_id = :id",
                         ids: current_user.friends.pluck(:id),
                         id: current_user.id)
                  .ordered
                  .page(params[:page])
                  .per(10)
  end
end
