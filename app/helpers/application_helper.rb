module ApplicationHelper
  # Devise helpers
  def resource_name
    :user
  end

  def resource_class
    User
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  # Friends requests helper
  def friend_requests
    current_user.received_friend_requests.includes(user: :profile)
  end

  # Semantic UI flash
  def flash_class(level)
    case level
    when 'success' then 'ui positive message'
    when 'error' then 'ui red message'
    when 'notice' then 'ui info message'
    when 'alert' then 'ui warning message'
    end
  end
end
