require 'line-bot-api'

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
        request_body = request.body.read
        signature = request.env['HTTP_X_LINE_SIGNATURE']

        events = parser.parse(body: request_body, signature: signature)

        events.each do |event|
          begin
            LineEvent.create!(
              event_type: event.type,
              user_id: event.dig('source', 'userId'),
              payload: event.to_h
            )
            Rails.logger.info "[LINE Webhook] LineEventを保存しました: user_id=#{event.dig('source', 'userId')}, event_type=#{event.type}"
          rescue ActiveRecord::RecordInvalid => e
            Rails.logger.error "[LINE Webhook] LineEvent保存失敗: #{e.message}"
          end
        end

        head :ok
      rescue Line::Bot::V2::WebhookParser::InvalidSignatureError
        head :bad_request
      rescue StandardError => e
        Rails.logger.error "[LINE Webhook] Error in callback: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
        head :internal_server_error
      end
    end
  end

  private

  def client
    @client ||= Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: ENV['LINE_CHANNEL_TOKEN']
    )
  end

  def parser
    @parser ||= Line::Bot::V2::WebhookParser.new(
      channel_secret: ENV['LINE_CHANNEL_SECRET']
    )
  end
end
