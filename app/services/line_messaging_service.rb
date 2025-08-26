class LineMessagingService
  def send_message(user_id, message)
    body = {
      to: user_id,
      messages: [
        {
          type: 'text',
          text: message
        }
      ]
    }
    response = LineClientService.messaging_api_client.push_message(body)
    response
  rescue StandardError => e
    Rails.logger.error "LINEメッセージ送信エラー: #{e.message}"
    false
  end
end
