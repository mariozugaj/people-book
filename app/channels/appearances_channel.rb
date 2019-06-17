# frozen_string_literal: true

class AppearancesChannel < ApplicationCable::Channel
  def subscribed
    redis.set("user_#{current_user.slug}_online", '1')
    stream_from('appearances_channel')
    AppearanceBroadcastJob.perform_later(current_user.slug, true)
  end

  def unsubscribed
    redis.del("user_#{current_user.slug}_online")
    AppearanceBroadcastJob.perform_later(current_user.slug, false)
  end

  private

  def redis
    Redis.new
  end
end
