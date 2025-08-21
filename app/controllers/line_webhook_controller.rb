class LineWebhookController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:callback]
  protect_from_forgery except: [:callback]

  def callback
    if request.get?
      render plain: 'OK'
    elsif request.post?
      request_body = request.body.read
      Rails.logger.info "[LINE Webhook] Request body: #{request_body}"
      Rails.logger.info "[LINE Webhook] X-Line-Signature: #{request.env['HTTP_X_LINE_SIGNATURE']}"

      Rails.logger.info "[LINE Webhook] Channel Secret: #{ENV['LINE_CHANNEL_SECRET'].present? ? '設定済み' : '未設定'}"

      unless client.validate_signature(request_body, request.env['HTTP_X_LINE_SIGNATURE'].to_s)
        Rails.logger.error "[LINE Webhook] 署名検証に失敗しました"
        Rails.logger.error "[LINE Webhook] 期待する署名: #{OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), ENV['LINE_CHANNEL_SECRET'].to_s, request_body).unpack1('H*')}"
        return head :unauthorized
      end

      events = client.parse_events_from(request_body)
      Rails.logger.info "[LINE Webhook] Parsed events: #{events.inspect}"

      events.each do |event|
        Rails.logger.info "[LINE Webhook] Processing event: #{event.inspect}"

        case event
        when Line::Bot::Event::Message
          case event.type
          when Line::Bot::Event::MessageType::Text
            begin
              line_event = LineEvent.create!(
                event_type: 'message',
                user_id: event['source']['userId'],
                message_text: event.message['text'],
                source_type: event['source']['type'],
                payload: event
              )
              Rails.logger.info "[LINE Webhook] Created LineEvent: #{line_event.id}"
            rescue => e
              Rails.logger.error "[LINE Webhook] Failed to create LineEvent: #{e.message}"
              Rails.logger.error e.backtrace.join("\n")
              next
            end
          end
        end
      end

      head :ok
    end
  rescue => e
    Rails.logger.error "[LINE Webhook] Error in callback: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    head :internal_server_error
  end

  private

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end
end