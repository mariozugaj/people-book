module Search
  class Autocomplete
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def search
      [].tap do |column|
        SearchController::CATEGORIES.each do |name, category_options|
          results = {}
          category_results = Search::CategorySearch.search(category_options, params)
          results[:name] = name
          results[:count] = category_results.total_count
          results[:results] = category_results.first(2).map(&:search_info)
          column << results
        end
      end
    end
  end
end
