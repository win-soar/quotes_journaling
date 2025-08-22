require 'line/bot'

# LINE Botクライアントを初期化するモジュール
module LineBot
  class Client
    class << self
      def client
        @client ||= begin
          Rails.logger.info '[LINE Bot] Initializing LINE Bot client...'

          unless ENV['LINE_CHANNEL_SECRET'].present? && ENV['LINE_CHANNEL_TOKEN'].present?
            Rails.logger.error '[LINE Bot] エラー: 必要な環境変数が設定されていません。LINE_CHANNEL_SECRET と LINE_CHANNEL_TOKEN を確認してください。'
            raise 'Missing LINE channel credentials'
          end

          Line::Bot::Client.new do |config|
            config.channel_secret = ENV['LINE_CHANNEL_SECRET']
            config.channel_token = ENV['LINE_CHANNEL_TOKEN']
          end
        rescue => e
          Rails.logger.error "[LINE Bot] LINE Bot client の初期化に失敗しました: #{e.message}"
          Rails.logger.error e.backtrace.join("\n")
          raise
        end
      end
    end
  end
end

# グローバルに利用可能なヘルパーメソッド
def line_client
  LineBot::Client.client
end
