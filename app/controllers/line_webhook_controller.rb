require 'line/bot/v2/messaging_api/core'

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
        Rails.logger.info "[LINE Webhook] POSTリクエスト受信・ボディ: \\n#{request_body}"
        head :ok
      rescue StandardError => e
        Rails.logger.error "[LINE Webhook] Error in callback: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
        head :internal_server_error
      end
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
      LineClientService.messaging_api_client
    rescue => e
      Rails.logger.error "[LINE Webhook] Failed to get LINE client: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise
    end
  end
end
