class DailyPostRecommendation
  def self.send_recommendations
    test_quote = Quote.first
    return unless test_quote

    User.with_line_account.find_each do |user|
      send_recommendation(user, test_quote)
      puts "テストメッセージを送信しました: #{user.line_user_id}"
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
