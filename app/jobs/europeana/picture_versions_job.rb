class Europeana::PictureVersionsJob < ActiveJob::Base
  queue_as :default
  include PictureVersionHelper

  def perform(id)
    picture = Alchemy::Picture.find(id)
    Europeana::Elements::Image::VERSIONS.values.compact.each do |settings|
      Rails.logger.info "Creating #{JSON.generate(settings)} of picture #{id}"
      next if settings[:size].nil?
      picture_version(picture, settings).data
      true
    end
  end
end
