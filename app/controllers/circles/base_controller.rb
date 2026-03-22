class Circles::BaseController < ApplicationController
  before_action :require_circle_member!

  private

  def require_circle_member!
    unless current_user&.circle_user?
      redirect_to root_path, alert: 'サークルメンバー専用ページです'
    end
  end
end
