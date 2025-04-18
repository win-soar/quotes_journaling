class QuotesController < ApplicationController
  def new
    @quote = Quote.new
  end

  def index
    @quotes = Quote.includes(:user).order(created_at: :desc)
  end

  def create
    @quote = current_user.quotes.build(quote_params)
    if @quote.save
      redirect_to quotes_path, notice: 'クォーツを投稿しました。'
    else
      render :new, status: :unprocessable_entity
    end
  end
end

private

def quote_params
  params.require(:quote).permit(:title, :author, :note, :source, :source_writer, :category)
end
