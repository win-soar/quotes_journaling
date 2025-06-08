require "active_storage/service/s3_service"

class ActiveStorage::Service::CloudflareR2Service < ActiveStorage::Service::S3Service
  private

  def upload_with_checksum(key, io, checksum: nil, **options)
    instrument :upload, key: key, checksum: checksum do
      object_for(key).put(body: io, **options)
    end
  end
end
