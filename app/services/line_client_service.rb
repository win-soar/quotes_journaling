require 'line/bot/v2/messaging_api/core'

class LineClientService
  def self.messaging_api_client
    @messaging_api_client ||= Line::Bot::V2::MessagingApi::Core.new(
      channel_access_token: ENV['LINE_CHANNEL_TOKEN']
    )
  end
end
