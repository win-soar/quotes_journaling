require 'line-bot-api'

client = Line::Bot::V2::MessagingApi::ApiClient.new(
  channel_access_token: ENV['LINE_CHANNEL_TOKEN']
)

Rails.application.config.line_client = client
