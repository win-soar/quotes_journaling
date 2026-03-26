module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: [:google_oauth2]

    def google_oauth2
      auth = request.env["omniauth.auth"]

      if (join_token = session.delete(:circle_join_token))
        circle = Circle.find_by(join_token: join_token)

        if circle
          existing = User.find_by(provider: auth.provider, uid: auth.uid, circle_id: circle.id)

          if existing
            # 既存サークルメンバー → そのままログイン
            sign_in_and_redirect existing, event: :authentication
            flash[:notice] = "Googleアカウントでログインしました。"
          else
            # 新規 → circle パスワード検証ページへ
            session[:circle_oauth_data] = {
              'provider' => auth.provider,
              'uid'      => auth.uid,
              'email'    => auth.info.email,
              'name'     => auth.info.name
            }
            redirect_to circle_join__verify_circle_path(join_token: circle.join_token)
          end
        else
          sign_in_global(auth)
        end
      else
        sign_in_global(auth)
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

    private

    def sign_in_global(auth)
      user = User.from_omniauth(auth)
      if user.persisted?
        sign_in_and_redirect user, event: :authentication
        flash[:notice] = "Googleアカウントでログインしました。"
      else
        redirect_to root_path, alert: "認証に失敗しました: #{user.errors.full_messages.join(', ')}"
      end
    end
  end
end
