class DailyPostRecommendation
  def self.send_recommendations
    recommended_quote = find_recommended_quote
    return unless recommended_quote

    User.with_line_account.find_each do |user|
      send_recommendation(user, recommended_quote)
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
    message = {
      type: 'text',
      text: <<~MESSAGE
        #{date_str} 本日のおすすめクォーツ🌟

        "#{quote.content}"
        "#{quote.author}"

        "#{quote.user.name} さんの投稿"

        サイトで見る: #{Rails.application.routes.url_helpers.quote_url(quote)}
      MESSAGE
    }
    LineClientService.client.push_message(user.line_user_id, message)
  end
end
