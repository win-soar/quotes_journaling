class LikesController < ApplicationController
  before_action :set_quote

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

  private

  def set_quote
    @quote = Quote.find(params[:quote_id])
  end
end
