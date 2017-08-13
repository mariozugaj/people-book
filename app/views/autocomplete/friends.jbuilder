json.results do
  json.array! @search_results do |user|
    json.title user.name
    json.image user.avatar.url :thumb
    json.url "/messages/new?receiver_id=#{user.slug}"
  end
end
