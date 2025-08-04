Rails.application.config.session_store :cookie_store,
  key: '_quotes_journaling_session',
  same_site: :lax,
  secure: Rails.env.production?