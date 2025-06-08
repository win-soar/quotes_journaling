puts "[CloudflareR2Service] Initializer running..."

require Rails.root.join("app/services/active_storage/service/cloudflare_r2_service")

ActiveStorage::Service.configure(:CloudflareR2) do |config, _options|
  puts "[CloudflareR2Service] Configuring CloudflareR2Service..."
  ActiveStorage::Service::CloudflareR2Service.new(**config.symbolize_keys)
end
