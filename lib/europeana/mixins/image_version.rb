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
        original: { size: nil, format: 'jpeg', 'quality': nil },
        full: { size: '1600x1600', format: 'jpeg', 'quality': 85 },
        fullx2: { size: '3200x3200', format: 'jpeg', 'quality': 85 },
        half: { size: '800x800', format: 'jpeg', 'quality': 85 },
        halfx2: { size: '1600x1600', format: 'jpeg', 'quality': 85 },
        small: { size: '400x400', format: 'jpeg', 'quality': 85 },
        smallx2: { size: '800x800', format: 'jpeg', 'quality': 85 },
        thumbnail: { size: '400x400', format: 'jpeg', 'quality': 85 },
        thumbnailx2: { size: '800x800', format: 'jpeg', 'quality': 85 },
        thumbnail_png: { size: '400x400', format: 'png', 'quality': nil },
        facebook: { size: '1200x630', format: 'jpeg', quality: 85, crop: true, upsample: true },
        twitter: { size: '750x560', format: 'jpeg', quality: 85, crop: true, upsample: true },
      }.freeze

      def versions(name = 'image')
        @versions ||= {}
        @versions[name.to_sym] ||= begin
          image = @element.content_by_name(name)
          if image&.essence&.picture.present?
            versions_hash = {}
            VERSIONS.each_pair do |version, settings|
              picture = image.essence.picture
              alchemy_picture_version = picture_version_from_key(picture, version) || picture_version(picture, settings)
              url = version_url(alchemy_picture_version)
              versions_hash[version] = { url: url }
            end
            versions_hash
          else
            false
          end
        end
      end
    end
  end
end
