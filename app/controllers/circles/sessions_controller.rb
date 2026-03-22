class Circles::SessionsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_circle

  def new
  end

  def create
    @user = User.find_by(email: params[:email], circle_id: @circle.id)
    if @user&.valid_password?(params[:password])
      sign_in(@user)
      redirect_to circle_quotes_path(@circle), notice: 'ログインしました'
    else
      flash.now[:alert] = 'メールアドレスまたはパスワードが正しくありません'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_circle
    @circle = Circle.find_by!(join_token: params[:join_token])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: '無効なサークルURLです'
  end
end
