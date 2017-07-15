json.people do
  json.array! @people do |person|
    json.name person.name
    json.avatar person.profile.avatar.url :thumb
    json.url user_path(person)
    json.hometown person.profile.hometown
  end
end

if @people.size > 5
  json.action do
    json.url search_path
    json.text "View all #{@people.size} results"
  end
end
