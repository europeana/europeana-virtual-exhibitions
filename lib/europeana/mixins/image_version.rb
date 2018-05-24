# frozen_string_literal: true

module Europeana
  module Mixins
    module ImageVersion
      include PictureVersionHelper

      # Hash that defines which versions of an image are
      # available and will be created on upload

      # The key is the name of the version and the value is
      # a simple hash with the following keys:
      # size: nil|100x100
      # format: jpeg|png
      # quality: nil|85 (jpeg quality)
      # crop: true if the image can be cropped
      # upsample: true if you want the image to use the entire canvas
      VERSIONS = {
        original: { size: nil, format: 'jpeg', quality: nil },
        full: { size: '1600x1600', format: 'jpeg', quality: 85 },
        fullx2: { size: '3200x3200', format: 'jpeg', quality: 85 },
        half: { size: '800x800', format: 'jpeg', quality: 85 },
        thumbnail: { size: '400x400', format: 'jpeg', quality: 85 },
        facebook: { size: '1200x630', format: 'jpeg', quality: 85, crop: true, upsample: true },
        twitter: { size: '750x560', format: 'jpeg', quality: 85, crop: true, upsample: true }
      }.freeze

      def versions(name = 'image')
        @versions ||= {}
        @versions[name.to_sym] ||= begin
          image = @element.content_by_name(name)
          if image&.essence&.picture.present?
            picture = image.essence.picture
            versions_file_uuids_pairs = Alchemy::PictureVersion.joins("INNER JOIN alchemy_dragonfly_signatures on alchemy_picture_versions.signature = alchemy_dragonfly_signatures.signature").where(alchemy_dragonfly_signatures: {picture_id: picture.id, version_key: VERSIONS.keys}).pluck('alchemy_dragonfly_signatures.version_key', :file_uuid)
            return_versions = versions_file_uuids_pairs.map { |version_key, file_uuid| [version_key.to_sym, { url: picture_version_url(file_uuid) }] }.to_h
            puts return_versions.inspect
            missing_versions = VERSIONS.keys - return_versions.keys
            VERSIONS.slice(missing_versions).each_with_object(return_versions) do |(version_key, settings), memo|
              alchemy_picture_version = picture_version(picture, settings)
              url = picture_version_url(alchemy_picture_version.file_uuid)
              memo[version_key] = { url: url }
            end
            return_versions
          else
            false
          end
        end
      end
    end
  end
end
