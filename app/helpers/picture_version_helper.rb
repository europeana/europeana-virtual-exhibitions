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
  # Looks up the remote url for a Alchemy::PictureVersion.
  #
  # @param version_picture [Alchemy::PictureVersion]
  def picture_version_url(version)
    if Dragonfly.app(:alchemy_pictures).datastore.is_a?(Dragonfly::S3DataStore)
      Dragonfly.app(:alchemy_pictures).datastore.url_for(version.file_uuid).sub(%r(\Ahttp://), 'https://')
    else
      full_url(version.file_uuid)
    end
  end

  def full_url(file_uuid)
    host = ENV.fetch('CDN_HOST', ENV.fetch('APP_HOST', 'localhost'))
    protocol = host == 'localhost' ? 'http' : 'https'
    port = ENV.fetch('APP_PORT', nil)
    "#{protocol}://#{host}#{port.nil? ? '' : ':' + port}#{file_uuid}"
  end

  #
  # @param picture [Alchemy::Picture]
  # @param version_key [Symbol]
  # @return Alchemy::PictureVersion
  def picture_version_from_key(picture, version_key)
    dragonfly_signature = Alchemy::DragonflySignature.find_by(picture_id: picture.id, version_key: version_key)
    Alchemy::PictureVersion.find_by_signature(dragonfly_signature.signature) if dragonfly_signature
  end
end
