require 'line/bot'

def line_client
  unless ENV['LINE_CHANNEL_SECRET'].present? && ENV['LINE_CHANNEL_TOKEN'].present?
    Rails.logger.warn '[LINE Bot] 環境変数が未設定です（assets:precompile等の一時的な処理の可能性あり）'
    return nil
  end

  @line_client ||= Line::Bot::Client.new do |config|
    config.channel_secret = ENV['LINE_CHANNEL_SECRET']
    config.channel_token = ENV['LINE_CHANNEL_TOKEN']
  end
end
