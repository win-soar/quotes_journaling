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

    messages = [
      {
        type: 'text',
        text: message
      }
    ]
    puts "push_message args: to=#{user_id}, messages=#{messages.inspect}"

    LineClientService.messaging_api_client.push_message(user_id, messages)

  rescue StandardError => e
    Rails.logger.error "LINEメッセージ送信エラー: #{e.message}"
    false
  end
end
