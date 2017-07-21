module Search
  class Users < ApplicationSearch
    def query
      User.includes(:profile)
          .ransack(name_cont: params)
          .result(distinct: true)
    end

    def search_result
      results(query)
    end

    def result_title(object)
      object.name
    end

    def result_image(object)
      object.avatar.url(:thumb)
    end

    def result_url(object)
      Rails.application.routes.url_helpers.user_path(object)
    end

    def result_description(object)
      object.profile.hometown
    end
  end
end
