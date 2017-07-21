module Search
  class ApplicationSearch
    attr_accessor :params, :limit

    def initialize(params, limit = nil)
      @params = params
      @limit = limit
    end

    def results(search_query)
      [].tap do |column|
        search_query.first(limit).each do |object|
          json = {}
          json[:title] = result_title(object)
          json[:image] = result_image(object)
          json[:url] = result_url(object)
          json[:description] = result_description(object)
          column << json
        end
      end
    end
  end
end
