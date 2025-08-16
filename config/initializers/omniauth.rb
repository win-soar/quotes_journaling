Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth.config.allowed_request_methods = %i[post get]
  OmniAuth.config.silence_get_warning = true
  OmniAuth.config.request_validation_phase = ->(env) {} if Rails.env.development?
  OmniAuth.config.request_validation_phase = ->(env) {} if Rails.env.production?
end
