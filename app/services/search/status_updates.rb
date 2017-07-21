module Search
  class StatusUpdates < ApplicationSearch
    def query
      StatusUpdate.includes(author: :profile)
                  .ransack(text_cont: params)
                  .result
    end

    def search_result
      results(query)
    end

    def result_title(object)
      object.text.truncate(50)
    end

    def result_image(object)
      object.image.url(:thumb)
    end

    def result_url(object)
      Rails.application.routes.url_helpers.status_update_path(object)
    end

    def result_description(object)
      object.author_name
    end
  end
end
