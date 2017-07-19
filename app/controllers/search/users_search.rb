class Search::UsersSearch
  def query(search_params, options = {})
    limit = options.fetch(:limit, nil)
    User.includes(:profile)
        .ransack(name_cont: search_params)
        .result(distinct: true)
        .limit(limit)
  end

  def result(search_params, options = {})
    [].tap do |column|
      query(search_params, options).each do |user|
        result = {}
        result[:title] = user.name
        result[:image] = user.avatar.url :thumb
        result[:url] = Rails.application.routes.url_helpers.user_path(user)
        result[:description] = user.profile.hometown || ''
        column << result
      end
    end
  end
end
