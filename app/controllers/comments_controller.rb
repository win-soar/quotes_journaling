class CommentsController < ApplicationController

  def create
    @quote = Quote.find(params[:quote_id])
    @comment = @quote.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to quote_path(@quote), notice: 'コメントを投稿しました。'}
      end
    else
      @comments = @quote.comments.includes(:user).order(created_at: :asc)
      respond_to do |format|
        format.html { render 'quotes/show', status: :unprocessable_entity }
      end
    end
  end

  def show
    @quote = Quote.find(params[:id])
    @comment = Comment.new
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
