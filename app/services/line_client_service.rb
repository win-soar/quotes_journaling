require 'line-bot-api'

class LineClientService
  def self.messaging_api_client
    @messaging_api_client ||= Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: ENV.fetch('LINE_CHANNEL_TOKEN')
    )
  end

  def self.channel_token
    ENV.fetch('LINE_CHANNEL_TOKEN')
  end
end
