class LineMessagingService
  def send_message(user_id, message)
    message = {
      type: 'text',
      text: message
    }
    LineClientService.client.push_message(user_id, message)
  rescue => e
    Rails.logger.error "LINEメッセージ送信エラー: #{e.message}"
    false
  end
end
