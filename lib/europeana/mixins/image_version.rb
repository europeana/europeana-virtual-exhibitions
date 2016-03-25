module Europeana
  module Mixins
    module ImageVersion
      VERSIONS = {
        original: nil,
        full: '1600x1600',
        fullx2: '3200x3200',
        half: '800x800',
        halfx2: '1600x1600',
        small: '400x400',
        smallx2: '800x800',
        thumbnail: '400x400',
        thumbnailx2: '800x800'
      }

      def versions(name = 'image')
        image = @element.content_by_name(name)
        return nil if image.nil?
        Hash[VERSIONS.map {|version,size| [version, 
          {
            url: image.essense.picture_url(image_size: size)
          }
        ]}]
      end
    end
  end
end
