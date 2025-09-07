require 'line/bot'

class LineClientService
  def self.messaging_api_client
    @messaging_api_client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV.fetch('LINE_CHANNEL_SECRET')
      config.channel_token  = ENV.fetch('LINE_CHANNEL_TOKEN')
    end
  end

  def self.channel_token
    ENV.fetch('LINE_CHANNEL_TOKEN')
  end
end
