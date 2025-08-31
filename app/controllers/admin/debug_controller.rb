module Admin
  class DebugController < ActiveAdmin::BaseController
    def active_admin_namespace
      ActiveAdmin.application.namespace(:admin)
    end

    def gemfile_lock
      render plain: File.read(Rails.root.join('Gemfile.lock'))
    end

    def line_bot_initializer
      render plain: File.read(Rails.root.join('config/initializers/line_bot.rb'))
    end
  end
end
