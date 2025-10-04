class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    saved = @user.save

    unless params[:agree_terms] == "1"
      @user.errors.add(:base, "利用規約・プライバシーポリシーへの同意が必要です。")
    end

    if @user.errors.any?
      render :new, status: :unprocessable_entity
    else
      auto_login(@user)
      redirect_to root_path, notice: "アカウントを作成しました。"
    end
  end

  def show
    @user = User.find(params[:id])
    @quotes = @user.quotes.order(created_at: :desc)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'プロフィールを更新しました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def registration
    @user = current_user
    @user.destroy
    redirect_to root_path, notice: 'アカウントを削除しました。'
  end

  def unlink_line_account
    current_user.update(line_user_id: nil, line_display_name: nil)
    redirect_back fallback_location: root_path, notice: 'LINE連携を解除しました'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :bio, :avatar)
  end
end
