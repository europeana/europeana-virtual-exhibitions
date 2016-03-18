class Europeana::PictureVersionsJob < ActiveJob::Base
  queue_as :default

  def perform(id)
    Rails.logger.info "Create versions for picture with id #{id}"

    Europeana::Elements::Image::VERSIONS.values.compact.each do |size|
      Rails.logger.info "Creating #{size} of picture #{id}"

      picture = Alchemy::Picture.find(id)

      Alchemy::PictureVersion.from_cache(picture.resize(size)).data
      true
    end
  end
end
