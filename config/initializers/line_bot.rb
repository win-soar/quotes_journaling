# LINE Botクライアントを直接初期化
Rails.logger.info '[LINE Bot] Initializing LINE Bot client...'

# 環境変数のチェック
unless ENV['LINE_CHANNEL_SECRET'].present? && ENV['LINE_CHANNEL_TOKEN'].present?
  Rails.logger.error '[LINE Bot] エラー: 必要な環境変数が設定されていません。LINE_CHANNEL_SECRET と LINE_CHANNEL_TOKEN を確認してください。'
  raise 'Missing LINE channel credentials'
end

begin
  LINE_CLIENT = Line::Bot::Client.new do |config|
    config.channel_secret = ENV['LINE_CHANNEL_SECRET']
    config.channel_token = ENV['LINE_CHANNEL_TOKEN']
  end

  Rails.logger.info '[LINE Bot] LINE Bot client initialized successfully'
rescue => e
  Rails.logger.error "[LINE Bot] LINE Bot client の初期化に失敗しました: #{e.message}"
  Rails.logger.error e.backtrace.join("\n")
  raise
end

def line_client
  LINE_CLIENT
end
