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
        @results_count = @people.size + @status_updates.size
        @people = @people.limit(3)
        @status_updates = @status_updates.limit(3)
      }
    end
  end

  private

  def search_params
    @query ||= params[:q]
  end
end
