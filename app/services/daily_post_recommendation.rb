class DailyPostRecommendation
  def self.send_daily_recommendations
    quote = find_recommended_quote
    return unless quote

    User.with_line_account.find_each do |user|
      send_recommendation(user, quote)
      puts "おすすめ名言を送信しました: #{user.line_user_id}"
    end
  end

  def self.send_test_message_to_user(user_id)
    message = Line::Bot::V2::MessagingApi::TextMessage.new(
      text: "9/#{Date.today.day}(#{I18n.t('date.abbr_day_names')[Date.today.wday]}) 本日のおすすめクォーツ🌟\n\nテストメッセージです"
    )

    request = Line::Bot::V2::MessagingApi::PushMessageRequest.new(
      to: user_id,
      messages: [message]
    )

    begin
      LineClientService.messaging_api_client.push_message(
        push_message_request: request
      )
      Rails.logger.info "テストメッセージを送信しました: #{user_id}"
    rescue => e
      Rails.logger.error "LINEメッセージ送信エラー: #{e.message}"
      raise
    end
  end

  def self.find_recommended_quote
    yesterday = Date.yesterday
    quotes = Quote.where(created_at: yesterday.beginning_of_day..yesterday.end_of_day)
                  .left_joins(:likes)
                  .group(:id)
                  .order('COUNT(likes.id) DESC', 'quotes.created_at ASC')
    quotes.first if quotes.any?
  end

  def self.send_recommendation(user, quote)
    date_str = Date.current.strftime("%-m/%-d(%a)")
    message = <<~MESSAGE
      #{date_str} 本日のおすすめクォーツ🌟

      "#{quote.title}"
      "#{quote.author}"

      "#{quote.user.name} さんの投稿"

      サイトで見る: #{Rails.application.routes.url_helpers.quote_url(quote)}
    MESSAGE

    LineMessagingService.new.send_message(user.line_user_id, message)
  end
end
