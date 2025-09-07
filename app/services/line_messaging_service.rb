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

    puts "push_message args: #{ { channel_access_token: LineClientService.channel_token, body: body }.inspect }"

    LineClientService.messaging_api_client.push_message(
      channel_access_token: LineClientService.channel_token,
      body: body
    )
  rescue StandardError => e
    Rails.logger.error "LINEメッセージ送信エラー: #{e.message}"
    false
  end
end
