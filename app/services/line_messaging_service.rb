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
    LineClientService.messaging_api_client.push_message(body)
  rescue StandardError => e
    Rails.logger.error "LINEメッセージ送信エラー: #{e.message}"
    false
  end
end
