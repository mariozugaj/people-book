json.results do
  json.category1 do
    json.name 'People'
    json.results do
      json.array! @people do |person|
        json.name person.name
        json.avatar person.profile.avatar.url :thumb
        json.url user_path(person)
        json.description person.profile.hometown
      end
    end
  end

  json.category2 do
    json.name 'Status updates'
    json.results do
      json.array! @status_updates do |s_update|
        json.name truncate s_update.text, length: 50
        json.avatar s_update.author.profile.avatar.url :thumb
        json.url status_update_path(s_update)
        json.description s_update.author.name
      end
    end
  end
end

if @people.size > 5 || @status_updates.size > 5
  json.action do
    json.url search_path
    json.text "View all #{@people.size + @status_updates.size} results"
  end
end
