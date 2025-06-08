puts "[CloudflareR2Service] Initializer running..."

require Rails.root.join("app/services/active_storage/service/cloudflare_r2_service")

Rails.application.config.to_prepare do
  ActiveStorage::Service::Registry.register(
    "CloudflareR2", ActiveStorage::Service::CloudflareR2Service
  )
end
