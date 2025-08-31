require 'line/bot/v2/messaging_api/api_client'

class LineClientService
  def self.messaging_api_client
    @messaging_api_client ||= Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: ENV['LINE_CHANNEL_TOKEN']
    )
  end
end
