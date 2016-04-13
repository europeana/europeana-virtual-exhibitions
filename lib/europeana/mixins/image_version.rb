module Europeana
  module Mixins
    module ImageVersion
      VERSIONS = {
        original: {size: nil, format: 'jpeg', 'quality': 85 },
        full: {size: '1600x1600', format: 'jpeg', 'quality': 85 },
        fullx2: {size: '3200x3200', format: 'jpeg', 'quality': 85 },
        half: {size: '800x800', format: 'jpeg', 'quality': 85 },
        halfx2: {size: '1600x1600', format: 'jpeg', 'quality': 85 },
        small: {size: '400x400', format: 'jpeg', 'quality': 85 },
        smallx2: {size: '800x800', format: 'jpeg', 'quality': 85 },
        thumbnail: {size: '400x400', format: 'jpeg', 'quality': 85 },
        thumbnailx2: {size: '800x800', format: 'jpeg', 'quality': 85 },
        thumbnail_png: {size: '400x400', format: 'png', 'quality': nil }
      }

      def versions(name = 'image')
        image = @element.content_by_name(name)
        return false if image.nil? || image.essence.picture.nil?
        Hash[VERSIONS.map {|version,settings| [version,
          {
            url: image.essence.picture_url(image_size: settings[:size], format: settings[:format], quality: settings[:quality])
          }
        ]}]
      end
    end
  end
end
