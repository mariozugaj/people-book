class AutocompleteController < ApplicationController
  before_action :set_search_term

  def index
    @search_results = Search::Autocomplete.new(params).search
  end

  private

  def set_search_term
    @search_term = params[:q]
  end
end
