module Search
  class CategorySearch
    def self.search(category_options = [], params)
      category_options[0].search params[:q],
                                 fields: [category_options[1]],
                                 match: :text_middle,
                                 includes: category_options[2],
                                 page: params[:page],
                                 per_page: 12
    end
  end
end
