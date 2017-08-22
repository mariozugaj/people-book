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

  # Semantic UI flash
  def flash_class(level)
    case level
    when 'success' then 'green'
    when 'error' then 'red'
    when 'notice' then 'info'
    when 'alert' then 'warning'
    end
  end

  def online_status(user)
    content_tag :span, nil,
                class: class_string("ui empty circular label user-#{user.id}",
                                    'green' => user.online?)
  end
end
