require 'dragonfly'
require 'dragonfly/swift_data_store'

openstack_defaults = {
  openstack_auth_url: ENV.fetch('OPENSTACK_AUTH_URL', ''),
  openstack_username: ENV.fetch('OPENSTACK_USERNAME', ''),
  openstack_api_key: ENV.fetch('OPENSTACK_API_KEY', ''),
  storage_headers: {'x-amz-acl' => 'public-read'},
  url_scheme: 'https'
}
Dragonfly.app(:alchemy_pictures).configure do
  plugin :imagemagick
  datastore :swift,
    { container_name: ENV.fetch('IMAGES_CONTAINER_NAME', 'IMAGES_CONTAINER_NAME') }.merge(openstack_defaults)
  url_host ENV.fetch('CDN_HOST', 'http://localhost:3000')
end

Dragonfly.app(:alchemy_attachments).configure do
  datastore :swift,
    { container_name: ENV.fetch('ATTACHMENTS_CONTAINER_NAME', 'ATTACHMENTS_CONTAINER_NAME') }.merge(openstack_defaults)
  url_host ENV.fetch('CDN_HOST', 'http://localhost:3000')
end
