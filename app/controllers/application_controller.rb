class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, unless: :active_admin_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :verify_authenticity_token, if: :devise_controller?

  helper_method :current_user

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
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
