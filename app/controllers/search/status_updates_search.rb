class Search::StatusUpdatesSearch
  def query(search_params, options = {})
    limit = options.fetch(:limit, nil)
    StatusUpdate.includes(author: :profile)
                .ransack(text_cont: search_params)
                .result
                .limit(limit)
  end

  def result(search_params, options = {})
    [].tap do |column|
      query(search_params, options).each do |s_update|
        result = {}
        result[:title] = s_update.text.truncate(50)
        result[:image] = s_update.image.url(:thumb) if s_update.image
        result[:url] = Rails.application.routes.url_helpers.status_update_path(s_update)
        result[:description] = s_update.author_name || ''
        column << result
      end
    end
  end
end
