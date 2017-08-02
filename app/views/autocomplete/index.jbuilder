json.results do
  @search_results.each_with_index do |category, idx|
    json.set! "category#{idx + 1}" do
      json.name category[:name]
      json.results do
        json.array! category[:results] do |result|
          json.title result[:title]
          json.image result[:image] || ''
          json.url result[:url]
          json.description result[:description] || ''
        end
      end
    end
  end
end

if @search_results.map { |r| r[:count] }.inject(:+) > 6
  json.action do
    json.url search_users_path(q: @search_term)
    json.text "View all #{@search_results.map { |r| r[:count] }.inject(:+)} results"
  end
end
