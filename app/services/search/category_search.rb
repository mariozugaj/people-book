module Search
  class CategorySearch
    # TODO: add includes_per model after pull request #967
    def self.search(category_options = [], params)
      category_options[0].search params[:q],
                                 fields: [category_options[1]],
                                 match: :text_middle,
                                 page: params[:page],
                                 per_page: 12
    end
  end
end
