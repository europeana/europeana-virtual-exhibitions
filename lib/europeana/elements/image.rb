module Europeana
  module Elements
    class Image < Europeana::Elements::Base
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
      def versions
        image = @element.content_by_name('image').essence
        c = {}
        VERSIONS.each do |version, size|
          c[version] = {url: image.picture_url(image_size: size)}
        end
        c
      end

      def caption
        @element.content_by_name('caption') ? @element.content_by_name('caption').essence.body : nil
      end

      protected
      def data
        {
          image: versions,
          caption: caption
        }
      end
    end
  end
end
