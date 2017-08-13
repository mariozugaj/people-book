json.results do
  json.total @count
  json.notifications do
    json.array! @notifications do |notification|
      json.id notification.id
      json.unread !notification.read?
      json.template render partial: "notifications/#{notification.notifiable_type.underscore.pluralize}/#{notification.action}",
                           locals: { notification: notification },
                           formats: [:html]
    end
  end
end
