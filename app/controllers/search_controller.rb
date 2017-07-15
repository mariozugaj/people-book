class SearchController < ApplicationController

  def index
    @people = User.includes(:profile)
                  .ransack(name_cont: params[:q])
                  .result(distinct: true)
                  .limit(5)
    respond_to do |format|
      format.json
      format.html
    end
  end
end
