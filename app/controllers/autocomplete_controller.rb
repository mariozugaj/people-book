# frozen_string_literal: true

class AutocompleteController < ApplicationController
  before_action :set_search_term

  def index
    @search_results = Search::Autocomplete.new(@search_term).results
  end

  def friends
    @search_results = current_user.friends.where('name ILIKE ?', "%#{@search_term}%")
  end

  private

  def set_search_term
    @search_term = params[:q]
  end
end
