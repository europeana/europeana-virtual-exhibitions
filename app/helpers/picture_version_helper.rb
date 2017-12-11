# frozen_string_literal: true

module PictureVersionHelper
  ##
  # Looks up an Alchemy::PictureVersion from the DB using the
  # from_cache method. If the image does not exist, it will be created and persisted.
  #
  # @param picture [Alchemy::Picture]
  # @param settings [Hash]
  # @return Alchemy::PictureVersion
  def picture_version(picture, settings = {})
    options = []

    if settings[:format] && settings[:format] == 'jpeg' && settings[:quality]
      options << "-quality #{settings[:quality]}"
    end

    unless settings[:format]
      settings[:format] = 'jpeg'
    end

    dragonfly_job = if settings[:size] && settings[:crop]
                      picture.crop(settings[:size], false, false, settings[:upsample] || false)
                    else
                      picture.resize(settings[:size])
                    end

    dragonfly_job = dragonfly_job.encode(settings[:format], options.compact.join(' '))
    Alchemy::PictureVersion.from_cache(dragonfly_job)
  end

  ##
  # Looks up the remote url for a Alchemy::PictureVersion, only works for S3DataStore.
  #
  # @param version_picture [Alchemy::PictureVersion]
  def picture_version_url(version)
    if Dragonfly.app(:alchemy_pictures).datastore.is_a?(Dragonfly::S3DataStore)
      Dragonfly.app(:alchemy_pictures).datastore.url_for(version.file_uuid)
    end
  end
end
