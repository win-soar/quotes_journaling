require Rails.root.join("app/services/active_storage/service/cloudflare_r2_service")

ActiveSupport.on_load(:active_storage) do
  ActiveStorage::Service.url_resolver.define(:cloudflare_r2) { |service| service.url }

  ActiveStorage::Service.configure(
    "CloudflareR2",
    ActiveStorage::Service::CloudflareR2Service
  )
end
