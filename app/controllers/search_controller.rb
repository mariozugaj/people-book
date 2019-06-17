# frozen_string_literal: true

class SearchController < ApplicationController
  before_action :set_search_term

  CATEGORIES = {
    'Users' => [User, :name, [:profile]],
    'Status updates' => [StatusUpdate, :text, [:author]],
    'Comments' => [Comment, :text, %i[commentable author]],
    'Images' => [Image, :description, [:author]]
  }.freeze

  def users
    @resources = Search::CategorySearch.search(CATEGORIES['Users'], params)
  end

  def status_updates
    @resources = Search::CategorySearch.search(CATEGORIES['Status updates'], params)
  end

  def images
    @resources = Search::CategorySearch.search(CATEGORIES['Images'], params)
  end

  def comments
    @resources = Search::CategorySearch.search(CATEGORIES['Comments'], params)
  end

  private

  def set_search_term
    @search_term = params[:q]
  end
end
