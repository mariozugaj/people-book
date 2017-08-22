class NotificationRelayJob < ApplicationJob
  queue_as :default

  def perform(recipients, actor, action, notifiable)
    recipients.each do |recipient|
      Notification.create(recipient: recipient,
                          actor: actor,
                          action: action,
                          notifiable: notifiable)
    end
  end
end
