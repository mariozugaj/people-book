class AppearancesChannel < ApplicationCable::Channel
  def subscribed
    redis.set("user_#{current_user.slug}_online", '1')
    stream_from('appearances_channel')
    ActionCable.server.broadcast 'appearances_channel',
                                 user_id: current_user.slug,
                                 online: true
  end

  def unsubscribed
    redis.del("user_#{current_user.slug}_online")
    ActionCable.server.broadcast 'appearances_channel',
                                 user_id: current_user.slug,
                                 online: false
  end

  private

  def redis
    Redis.new
  end
end
