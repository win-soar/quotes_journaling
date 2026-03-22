class Circles::QuotesController < Circles::BaseController
  def index
    @quotes = Quote.in_circle(current_circle)
                   .includes(:user)
                   .order(created_at: :desc)
                   .page(params[:page]).per(10)
  end

  def show
    @quote = scoped_quotes.find(params[:id])
    @comment = @quote.comments.build
    @comments = @quote.comments.includes(:user).order(created_at: :desc)
  end

  def new
    @quote = Quote.new
  end

  def create
    @quote = current_user.quotes.build(quote_params)

    unless params[:agree_guidelines] == "1"
      @quote.errors.add(:base, '引用元・著作権への確認に✓が必要です。')
    end

    if @quote.errors.any? || !@quote.save
      render :new, status: :unprocessable_entity
    else
      redirect_to circle_quotes_path(current_circle), notice: 'クォーツを投稿しました。'
    end
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
      redirect_to circle_quote_path(current_circle, @quote), notice: 'クォーツを更新しました。'
    end
  end

  def destroy
    @quote = current_user.quotes.find(params[:id])
    @quote.destroy!
    redirect_to circle_quotes_path(current_circle), notice: 'クォーツを削除しました。'
  end

  def search
  end

  def search_result
    @quotes = Quote.in_circle(current_circle)
    if params[:title].present?
      @quotes = @quotes.where("title ILIKE ?", "%#{params[:title]}%")
    end
    if params[:author].present?
      @quotes = @quotes.where("author ILIKE ?", "%#{params[:author]}%")
    end
    if params[:categories].present?
      @quotes = @quotes.where(category: params[:categories].map { |c| Quote.categories[c] })
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

  private

  def scoped_quotes
    Quote.in_circle(current_circle)
  end

  def quote_params
    params.require(:quote).permit(:title, :author, :note, :source, :source_writer, :category)
  end
end
