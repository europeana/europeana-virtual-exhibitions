require 'dragonfly'
require 'dragonfly/swift_data_store'
require 'dragonfly/s3_data_store'

if ENV.fetch('DISABLE_SSL_VERIFY', false)
  Excon.defaults[:ssl_verify_peer] = false
end

openstack_defaults = {
  openstack_auth_url: ENV.fetch('OPENSTACK_AUTH_URL', ''),
  openstack_username: ENV.fetch('OPENSTACK_USERNAME', ''),
  openstack_api_key: ENV.fetch('OPENSTACK_API_KEY', ''),
  storage_headers: {'x-amz-acl' => 'public-read'},
  url_scheme: 'https'
}

s3_defaults = {
  bucket_name: ENV.fetch('AWS_DIRECTORY', ''),
  access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID', ''),
  secret_access_key: ENV.fetch('AWS_SECRET_ACCES_KEY', ''),
  region: ENV.fetch('AWS_REGION', '')
}

filestorage_provider = ENV.fetch('FILE_PROVIDER', 'file')

unless Rails.env.test?

  if filestorage_provider == 'AWS'

    Dragonfly.app(:alchemy_pictures).configure do
      plugin :imagemagick
      datastore :s3, { root_path: ENV.fetch('AWS_IMAGE_PREFIX', 'AWS_IMAGE_PREFIX') }.merge(s3_defaults)
    end
    Dragonfly.app(:alchemy_attachments).configure do
      datastore :s3, { root_path: ENV.fetch('AWS_ATTACHEMENT_PREFIX', 'AWS_ATTACHEMENT_PREFIX') }.merge(s3_defaults)
    end

  elsif filestorage_provider == 'OpenStack'

    Dragonfly.app(:alchemy_pictures).configure do
      plugin :imagemagick
      datastore :swift, { container_name: ENV.fetch('IMAGES_CONTAINER_NAME', 'IMAGES_CONTAINER_NAME') }.merge(openstack_defaults)
      url_host ENV.fetch('CDN_HOST', 'http://localhost:3000')
    end

    Dragonfly.app(:alchemy_attachments).configure do
      datastore :swift, { container_name: ENV.fetch('ATTACHMENTS_CONTAINER_NAME', 'ATTACHMENTS_CONTAINER_NAME') }.merge(openstack_defaults)
      url_host ENV.fetch('CDN_HOST', 'http://localhost:3000')
    end

  else

    Dragonfly.app(:alchemy_pictures).configure do
      datastore :file
    end

    Dragonfly.app(:alchemy_attachments).configure do
      datastore :file
    end

  end
end
