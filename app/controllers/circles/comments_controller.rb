class Circles::CommentsController < Circles::BaseController
  def create
    @quote = Quote.in_circle(current_circle).find(params[:quote_id])
    @comment = @quote.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to circle_quote_path(current_circle, @quote), notice: 'コメントを投稿しました。'
    else
      @comments = @quote.comments.includes(:user).order(created_at: :asc)
      render 'circles/quotes/show', status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
