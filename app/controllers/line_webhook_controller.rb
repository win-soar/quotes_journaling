require 'line/bot'

class LineWebhookController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:callback]
  skip_before_action :authenticate_user!, only: [:callback]
  protect_from_forgery except: [:callback]

  def callback
    Rails.logger.info "[LINE Webhook] === 新しいリクエスト開始 ==="

    if request.get?
      Rails.logger.info "[LINE Webhook] GETリクエストを受信"
      render plain: 'OK'
    elsif request.post?
      begin
        request_body = request.body.read.force_encoding('UTF-8')
        Rails.logger.info "[LINE Webhook] リクエストボディを読み込みました"

        Rails.logger.info "[LINE Webhook] 環境変数チェック:"
        Rails.logger.info "[LINE Webhook] - LINE_CHANNEL_SECRET: #{ENV['LINE_CHANNEL_SECRET'].present? ? '設定済み' : '未設定'}"
        Rails.logger.info "[LINE Webhook] - LINE_CHANNEL_TOKEN: #{ENV['LINE_CHANNEL_TOKEN'].present? ? '設定済み' : '未設定'}"

        signature = request.env['HTTP_X_LINE_SIGNATURE']
        unless signature
          Rails.logger.error "[LINE Webhook] エラー: X-Line-Signature ヘッダーが存在しません"
          return head :bad_request
        end

        Rails.logger.info "[LINE Webhook] 署名検証を開始します"
        Rails.logger.info "[LINE Webhook] リクエスト署名: #{signature}"

        channel_secret = ENV['LINE_CHANNEL_SECRET'].to_s
        expected_signature = OpenSSL::HMAC.digest(
          OpenSSL::Digest.new('sha256'),
          channel_secret,
          request_body
        ).unpack1('H*')

        Rails.logger.info "[LINE Webhook] 期待する署名: #{expected_signature}"

        unless client.validate_signature(request_body, signature)
          Rails.logger.error "[LINE Webhook] エラー: 署名検証に失敗しました"
          Rails.logger.error "[LINE Webhook] リクエスト署名: #{signature}"
          Rails.logger.error "[LINE Webhook] 期待する署名: #{expected_signature}"
          return head :unauthorized
        end

        Rails.logger.info "[LINE Webhook] 署名検証に成功しました"

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
              rescue StandardError => e
                Rails.logger.error "[LINE Webhook] Failed to create LineEvent: #{e.message}"
                Rails.logger.error e.backtrace.join("\n")
                next
              end
            end
          end
        end

        head :ok
      rescue StandardError => e
        Rails.logger.error "[LINE Webhook] Error in callback: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
        head :internal_server_error
      end
    end
  end

  private

  def client
    Rails.logger.info "[LINE Webhook] Channel Secret: #{ENV['LINE_CHANNEL_SECRET'].present? ? '設定済み' : '未設定'}"
    Rails.logger.info "[LINE Webhook] Channel Token: #{ENV['LINE_CHANNEL_TOKEN'].present? ? '設定済み' : '未設定'}"

    begin
      line_client
    rescue => e
      Rails.logger.error "[LINE Webhook] Failed to get LINE client: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise
    end
  end
end
