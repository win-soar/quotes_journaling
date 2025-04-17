class QuotesController < ApplicationController
  def index
    @quotes = Quote.includes(:user).order(created_at: :desc)
  end

  def create
  end
end
