require 'logger'
require 'line/bot'

class LineClientService
  def self.messaging_api_client
    @messaging_api_client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end
end
