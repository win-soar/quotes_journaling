module QuotesHelper
  def quote_category_class(quote)
    "quote-category--#{quote.category.present? ? quote.category.downcase.gsub(' ', '-') : 'default'}"
  end
end
