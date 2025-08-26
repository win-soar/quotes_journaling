class LineNotification
  class << self
    def send_test_message(user_id, message_text = "テストメッセージです")
      body = {
        to: user_id,
        messages: [
          {
            type: 'text',
            text: message_text
          }
        ]
      }
      response = LineClientService.messaging_api_client.push_message(body)
      { status: response.status, body: response.body }
    end
  end
end
