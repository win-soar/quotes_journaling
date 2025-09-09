require 'line-bot-api'

class LineTestController < ApplicationController
  def send_test_message
    user_id = params[:user_id]

    message = Line::Bot::V2::MessagingApi::TextMessage.new(
      text: "テストメッセージです"
    )

    request = Line::Bot::V2::MessagingApi::PushMessageRequest.new(
      to: user_id,
      messages: [message]
    )

    begin
      LineClientService.messaging_api_client.push_message(
        push_message_request: request
      )
      render plain: "テストメッセージを送信しました: #{user_id}"
    rescue => e
      logger.error "LINEメッセージ送信エラー: #{e.message}"
      render plain: "メッセージ送信に失敗しました", status: :internal_server_error
    end
  end
end
