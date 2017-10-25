module Search
  class Autocomplete
    attr_accessor :search_term, :categories, :fields, :includes

    def initialize(search_term)
      @search_term = search_term
      @categories = SearchController::CATEGORIES.values.map { |v| v[0] }
      @fields = SearchController::CATEGORIES.values.map { |v| v[1] }
    end

    def search
      Searchkick.search search_term,
                        index_name: categories,
                        fields: fields,
                        model_includes: build_includes,
                        indices_boost: { User => 2, StatusUpdate => 1 },
                        match: :text_middle
    end

    def results
      [].tap do |category_result|
        search_results = search
        category_result << { count: search_results.total_count }
        category_result << grouped_results(search_results)
      end
    end

    def grouped_results(search_results)
      grouped_results = search_results.group_by { |r| r.class.name }
      grouped_results.each_pair do |category, results|
        grouped_results[category] = results.first(2).map(&:search_info)
      end
    end

    private

    def build_includes
      includes = {}
      SearchController::CATEGORIES.values.each do |category|
        includes[category[0]] = category[2]
      end
      includes
    end
  end
end
