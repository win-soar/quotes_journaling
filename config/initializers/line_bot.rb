# LINE Botクライアントを初期化
module LineBot
  class Client
    class << self
      def client
        @client ||= begin
          Rails.logger.info '[LINE Bot] Initializing LINE Bot client...'

          unless ENV['LINE_CHANNEL_SECRET'].present? && ENV['LINE_CHANNEL_TOKEN'].present?
            Rails.logger.error '[LINE Bot] Missing required environment variables: LINE_CHANNEL_SECRET or LINE_CHANNEL_TOKEN'
            raise 'Missing LINE channel credentials'
          end

          Line::Bot::Client.new do |config|
            config.channel_secret = ENV['LINE_CHANNEL_SECRET']
            config.channel_token = ENV['LINE_CHANNEL_TOKEN']
          end
        rescue => e
          Rails.logger.error "[LINE Bot] Failed to initialize client: #{e.message}"
          raise
        end
      end
    end
  end
end

def line_client
  LineBot::Client.client
end
