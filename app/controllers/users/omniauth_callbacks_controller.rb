module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: [:google_oauth2]

    def google_oauth2
      auth = request.env["omniauth.auth"]

      if (join_token = session.delete(:circle_join_token))
        circle = Circle.find_by(join_token: join_token)
        @user = circle ? User.from_omniauth_for_circle(auth, circle) : User.from_omniauth(auth)
      else
        @user = User.from_omniauth(auth)
      end

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        flash[:notice] = "Googleアカウントでログインしました。"
      else
        redirect_to root_path, alert: "認証に失敗しました: #{@user.errors.full_messages.join(', ')}"
      end
    end

    def line
      auth = request.env['omniauth.auth']
      return unless current_user

      current_user.update(
        line_user_id: auth.uid,
        line_display_name: auth.info.name
      )
      redirect_to user_path(current_user), notice: 'LINEアカウントと連携しました'
    end
  end
end
