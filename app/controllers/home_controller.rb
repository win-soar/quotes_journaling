class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, raise: false rescue nil

  def index
  end

  def health_check
    render plain: "OK"
  end
end
