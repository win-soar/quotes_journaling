module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: [:google_oauth2]

    def google_oauth2
      @user = User.from_omniauth(request.env["omniauth.auth"])
      Rails.logger.info "Omniauth user: #{@user.inspect}"
      Rails.logger.info "Errors: #{@user.errors.full_messages}" if @user.errors.any?
      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
      else
        Rails.logger.error "Failed to persist user: #{@user.errors.full_messages}"
        redirect_to root_path, alert: "認証に失敗しました"
      end
    end
  end
end
