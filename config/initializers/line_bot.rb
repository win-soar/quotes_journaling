$line_bot_client = nil

Rails.application.reloader.to_prepare do
  require 'line/bot'

  $line_bot_client = Line::Bot::Client.new do |config|
    config.channel_secret = ENV['LINE_CHANNEL_SECRET']
    config.channel_token = ENV['LINE_CHANNEL_TOKEN']
  end
end

def line_client
  $line_bot_client
end
