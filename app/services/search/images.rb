module Search
  class Images < ApplicationSearch
    def query
      Image.includes(:author)
           .ransack(description_cont: params)
           .result
    end

    def search_result
      results(query)
    end

    def result_title(object)
      object.author_name
    end

    def result_image(object)
      object.image.url :thumb
    end

    def result_url(object)
      Rails.application.routes.url_helpers.image_path(object)
    end

    def result_description(object)
      object.description
    end
  end
end
