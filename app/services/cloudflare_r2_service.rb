class CloudflareR2Service < ActiveStorage::Service
  private

  def upload_with_checksum(key, io, checksum: nil, **options)
    instrument :upload, key: key, checksum: checksum do
      object_for(key).put(body: io, **options)
    end
  end
end