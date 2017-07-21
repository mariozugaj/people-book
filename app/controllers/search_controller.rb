class SearchController < ApplicationController
  SEARCH_CATEGORIES = %w[Users StatusUpdates Images]
  def index

  end

  def autocomplete
    @search_results = [].tap do |column|
      search_controllers.each_pair do |name, controller|
        results = {}
        results[:name] = name.to_s.underscore.humanize
        results[:results] = controller.new(search_params, 3).search_result
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
      controllers[category.to_sym] = "Search::#{category}".constantize
    end
    controllers
  end
end
