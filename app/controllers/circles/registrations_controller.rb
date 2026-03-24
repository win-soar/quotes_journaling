class Circles::RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_circle

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    @user.circle = @circle

    unless @circle.authenticate_circle_password(params[:circle_password])
      @user.errors.add(:base, 'サークルパスワードが正しくありません')
      return render :new, status: :unprocessable_entity
    end

    if @user.save
      sign_in(@user)
      redirect_to circle_quotes_path(@circle), notice: 'サークルに参加しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def google_oauth
    unless @circle.authenticate_circle_password(params[:circle_password])
      @user = User.new
      @user.errors.add(:base, 'サークルパスワードが正しくありません')
      return render :new, status: :unprocessable_entity
    end

    session[:circle_join_token] = @circle.join_token
    redirect_to user_google_oauth2_omniauth_authorize_path
  end

  private

  def set_circle
    @circle = Circle.find_by!(join_token: params[:join_token])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: '無効なサークルURLです'
  end

  def registration_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
