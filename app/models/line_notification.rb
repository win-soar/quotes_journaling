class LineNotification
  class << self
    def send_test_message(user_id, message_text = "テストメッセージです")
      client = Line::Bot::Client.new do |config|
        config.channel_secret = ENV['LINE_CHANNEL_SECRET']
        config.channel_token = ENV['LINE_CHANNEL_TOKEN']
      end

      message = {
        type: 'text',
        text: message_text
      }

      response = client.push_message(user_id, message)
      { status: response.code, body: response.body }
    end
  end
end