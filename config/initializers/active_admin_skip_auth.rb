Rails.application.config.to_prepare do
  if defined?(ActiveAdmin)
    ActiveAdmin.setup do |config|
      config.authentication_method = false
    end
  end
end