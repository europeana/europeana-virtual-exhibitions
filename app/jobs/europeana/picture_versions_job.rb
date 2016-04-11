class Europeana::PictureVersionsJob < ActiveJob::Base
  queue_as :default

  def perform(id)
    Rails.logger.info "Create versions for picture with id #{id}"

    Europeana::Elements::Image::VERSIONS.values.compact.each do |settings|
      Rails.logger.info "Creating #{JSON.generate(settings)} of picture #{id}"

      picture = Alchemy::Picture.find(id)

      options = []

      if settings[:format] && settings[:format] == 'jpeg'  && settings[:quality]
        options << "-quality #{settings[:quality]}"
      end

      if !settings[:format]
        settings[:format] = "jpeg"
      end

      Alchemy::PictureVersion.from_cache(picture.resize(settings[:size]).encode(settings[:format], options.join(" "))).data
      true
    end
  end
end
