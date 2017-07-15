class SearchController < ApplicationController

  def index
    return [] if !search_params
    @people         = User.includes(:profile)
                           .ransack(name_cont: params[:q])
                           .result(distinct: true)

    @status_updates = StatusUpdate.includes(author: :profile)
                                   .ransack(text_cont: params[:q])
                                   .result
    respond_to do |format|
      format.html
      format.json {
        @people = @people.limit(5)
        @status_updates = @status_updates.limit(5)
      }
    end
  end

  private

  def search_params
    @query ||= params[:q]
  end
end
