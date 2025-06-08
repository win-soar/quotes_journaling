puts "[CloudflareR2Service] Initializer running..."

require Rails.root.join("app/services/active_storage/service/cloudflare_r2_service")

ActiveStorage::Service.url_resolver { |name, config, *_args|
  if name == "CloudflareR2"
    puts "[CloudflareR2Service] Configuring CloudflareR2Service..."
    ActiveStorage::Service::CloudflareR2Service.new(**config.symbolize_keys)
  else
    nil # fallback to default
  end
}