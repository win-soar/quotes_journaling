class Admin::DebugController < ApplicationController
  before_action :authenticate_admin_user!

  def gemfile_lock
    render plain: File.read(Rails.root.join('Gemfile.lock'))
  end

  def line_bot_initializer
    render plain: File.read(Rails.root.join('config/initializers/line_bot.rb'))
  end
end
