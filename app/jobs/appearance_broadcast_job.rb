# frozen_string_literal: true

class AppearanceBroadcastJob < ApplicationJob
  queue_as :default

  def perform(id, status)
    user = User.find_by_slug(id)
    ActionCable.server.broadcast 'appearances_channel',
                                 user_id: user.slug,
                                 online: status
  end
end
