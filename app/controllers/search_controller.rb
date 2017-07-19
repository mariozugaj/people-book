class SearchController < ApplicationController
  SEARCH_CATEGORIES = %w[Users StatusUpdates]
  def index

  end

  def autocomplete
    @search_results = [].tap do |column|
      search_controllers.each_pair do |name, controller|
        results = {}
        results[:name] = name.to_s.underscore.humanize
        results[:results] = controller.new.result(search_params, limit: 3)
        column << results
      end
    end
  end

  private

  def search_params
    @query ||= params[:q]
  end

  def search_controllers
    controllers = {}
    SEARCH_CATEGORIES.each do |category|
      controllers[category.to_sym] = "Search::#{category}Search".constantize
    end
    controllers
  end
end
