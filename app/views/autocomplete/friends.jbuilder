# frozen_string_literal: true

json.results do
  json.array! @search_results do |user|
    json.title user.name
    json.image user.avatar.url :thumb
    json.url "/conversations/new?receiver_id=#{user.slug}"
  end
end
