class ApplicationController < ActionController::Base
  before_action :require_login
  helper_method :current_user
end
