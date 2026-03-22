class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, unless: :active_admin_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :verify_authenticity_token, if: :devise_controller?

  helper_method :current_user, :current_circle, :circle_mode?

  def current_circle
    current_user&.circle
  end

  def circle_mode?
    current_user&.circle_user? == true
  end

  def after_sign_in_path_for(resource)
    if resource.circle_user?
      circle_quotes_path(resource.circle)
    else
      stored_location_for(resource) || root_path
    end
  end

  private

  def active_admin_controller?
    is_a?(ActiveAdmin::BaseController)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name agree_terms])
  end
end
