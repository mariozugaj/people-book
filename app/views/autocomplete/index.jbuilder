# frozen_string_literal: true

json.results do
  idx = 1
  @search_results[1].each_pair do |category, results|
    json.set! "category#{idx}" do
      json.name category.underscore.humanize
      json.results do
        json.array! results do |result|
          json.title result[:title]
          json.image result[:image] || ''
          json.url result[:url]
          json.description result[:description] || ''
        end
      end
    end
    idx += 1
  end
end

if @search_results[0][:count] > 8
  json.action do
    json.url search_users_path(q: @search_term)
    json.text "View all #{@search_results[0][:count]} results"
  end
end
