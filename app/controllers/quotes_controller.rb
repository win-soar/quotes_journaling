class QuotesController < ApplicationController
  def new
    @quote = Quote.new
  end

  def index
    @quotes = Quote.includes(:user).order(created_at: :desc)
  end

  def create
    @quote = current_user.quotes.build(quote_params)
    @quote.save

    unless params[:agree_guidelines] == "1"
      @quote.errors.add(:base, '引用元・著作権への確認に✓が必要です。')
    end

    if @quote.errors.any?
      render :new, status: :unprocessable_entity
    else
      redirect_to root_path, notice: 'クォーツを投稿しました。'
    end
  end

  def show
    @quote = Quote.find(params[:id])
  end

  def edit
    @quote = current_user.quotes.find(params[:id])
  end

  def update
    @quote = current_user.quotes.find(params[:id])
    @quote.assign_attributes(quote_params)

    unless params[:agree_guidelines] == "1"
      @quote.errors.add(:base, '引用元・著作権への確認に✓が必要です。')
    end

    if @quote.errors.any?
      render :edit, status: :unprocessable_entity
    else
      @quote.save
      redirect_to @quote, notice: 'クォーツを更新しました。'
    end
  end

  def destroy
    @quote = current_user.quotes.find(params[:id])
    @quote.destroy!
    redirect_to root_path, notice: 'クォーツを削除しました。'
  end

  def search
  end

  def search_result
    @quotes = Quote.all
    if params[:title].present?
      @quotes = @quotes.where("title ILIKE ?", "%#{params[:title]}%")
    end
    if params[:author].present?
      @quotes = @quotes.where("author ILIKE ?", "%#{params[:author]}%")
    end
    if params[:category].present?
      @quotes = @quotes.where(category: Quote.categories[params[:category]])
    end
    if params[:note].present?
      @quotes = @quotes.where("note ILIKE ?", "%#{params[:note]}%")
    end
    if params[:source].present?
      @quotes = @quotes.where("source ILIKE ?", "%#{params[:source]}%")
    end
    if params[:source_writer].present?
      @quotes = @quotes.where("source_writer ILIKE ?", "%#{params[:source_writer]}%")
    end
  end
end

private

def quote_params
  params.require(:quote).permit(:title, :author, :note, :source, :source_writer, :category)
end
