class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :active_admin_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :verify_authenticity_token, only: [:create], if: -> { devise_controller? && action_name == 'create' }

  helper_method :current_user

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || quotes_path
  end

  private

  def active_admin_controller?
    is_a?(ActiveAdmin::BaseController)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :agree_terms])
  end
end
