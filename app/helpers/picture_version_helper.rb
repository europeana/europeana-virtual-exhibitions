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

    if settings[:format] && settings[:format] == 'jpeg'  && settings[:quality]
      options << "-quality #{settings[:quality]}"
    end

    if !settings[:format]
      settings[:format] = 'jpeg'
    end

    if settings[:size] && settings[:crop]
      dragonfly_job = picture.crop(settings[:size], false, false, settings[:upsample] || false)
    else
      dragonfly_job = picture.resize(settings[:size])
    end

    dragonfly_job = dragonfly_job.encode(settings[:format], options.compact.join(' '))
    Alchemy::PictureVersion.from_cache(dragonfly_job)
  end

  ##
  # Looks up the remote url for a Alchemy::PictureVersion, only works for S3DataStore.
  #
  # @param version_picture [Alchemy::PictureVersion]
  def version_url(version)
    if Dragonfly.app(:alchemy_pictures).datastore.is_a?(Dragonfly::S3DataStore)
      Dragonfly.app(:alchemy_pictures).datastore.url_for(version.file_uuid)
    else
      nil
    end
  end
end
