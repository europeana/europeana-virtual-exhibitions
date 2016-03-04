module Europeana
  module Elements
    class Image < Europeana::Elements::Base
      VERSIONS = {thumb: '100x100', original: nil, large: '500x500'}
      def versions
        image = @element.content_by_name('image').essence
        c = {}
        VERSIONS.each do |version, size|
          c[version] = {url: image.picture_url(image_size: size)}
        end
        c
      end

      def title
        @element.content_by_name('title').essence.body
      end

      protected
      def data
        {
          versions: versions,
          title: title
        }
      end
    end
  end
end
