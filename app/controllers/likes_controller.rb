class LikesController < ApplicationController
  before_action :set_quote, except: [:index]

  def create
    @like = @quote.likes.create(user: current_user)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to quotes_path }
    end
  end

  def destroy
    @like = @quote.likes.find_by(user: current_user)
    @like.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to quotes_path }
    end
  end

  def index
    @liked_quotes = Quote.joins(:likes)
                        .where(likes: { user_id: current_user.id })
                        .select('quotes.*, MAX(likes.created_at) AS liked_at')
                        .group('quotes.id')
                        .order('liked_at DESC')
  end

  private

  def set_quote
    @quote = Quote.find(params[:quote_id])
  end
end
