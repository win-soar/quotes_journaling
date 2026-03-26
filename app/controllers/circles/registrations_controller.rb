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

  # Step1: Google OAuthへリダイレクト（circle_join_token をセッションに保存）
  def google_oauth
    session[:circle_join_token] = @circle.join_token
    redirect_to user_google_oauth2_omniauth_authorize_path, allow_other_host: true
  end

  # Step2: Google認証後、新規ユーザーの場合はcircleパスワード入力ページを表示
  def verify_circle
    unless session[:circle_oauth_data]
      redirect_to circle_join__signup_path(join_token: @circle.join_token),
                  alert: 'セッションが切れました。もう一度お試しください'
    end
  end

  # Step3: circleパスワードを検証してユーザー作成 & ログイン
  def complete_circle_registration
    unless @circle.authenticate_circle_password(params[:circle_password])
      flash.now[:alert] = 'サークルパスワードが正しくありません'
      return render :verify_circle, status: :unprocessable_entity
    end

    oauth_data = session.delete(:circle_oauth_data)
    unless oauth_data
      return redirect_to circle_join__signup_path(join_token: @circle.join_token),
                         alert: 'セッションが切れました。もう一度お試しください'
    end

    user = User.where(provider: oauth_data['provider'], uid: oauth_data['uid'], circle_id: @circle.id)
               .first_or_initialize
    user.circle = @circle
    user.email ||= oauth_data['email']
    user.name  ||= oauth_data['name']
    password = Devise.friendly_token[0, 20]
    user.password = password
    user.password_confirmation = password

    if user.save
      sign_in(user)
      redirect_to circle_quotes_path(@circle), notice: 'サークルに参加しました'
    else
      render :verify_circle, status: :unprocessable_entity
    end
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
