class Europeana::PictureVersionsJob < ActiveJob::Base
  queue_as :default
  include PictureVersionHelper

  def perform(id)
    picture = Alchemy::Picture.find(id)
    Europeana::Elements::Image::VERSIONS.each_pair do |version_key, settings|
      Rails.logger.info "Creating #{JSON.generate(settings)} of picture #{id}"
      next if settings[:size].nil?
      version = picture_version(picture, settings)
      # call the .data method on the version. This will ensure the image data is available,
      # or will be generated and persisted to the datastore.
      version.data
      Alchemy::DragonflySignature.find_or_create_by(picture_id: id, version_key: version_key, signature: version.signature)
      true
    end
  end
end
