require 'line/bot'

class LineClientService
  def self.messaging_api_client
    @messaging_api_client ||= Line::Bot::V2::MessagingApi::ApiClient.new do |config|
      config.channel_secret = ENV.fetch('LINE_CHANNEL_SECRET')
      config.channel_token = ENV.fetch('LINE_CHANNEL_TOKEN')
    end
  end

  # v2 API用にchannel_tokenを取得するメソッド
  def self.channel_token
    ENV.fetch('LINE_CHANNEL_TOKEN')
  end
end
