module Europeana
  module Elements
    class Image < Europeana::Elements::Base
      include Europeana::Mixins::ImageVersion
      include Europeana::Mixins::ImageCredit

      def caption
        @element.content_by_name('caption') ? @element.content_by_name('caption').essence.body : nil
      end

      protected
      def data
        image = @element.content_by_name('image').essence
        {
          image: versions,
          caption: caption,
          image_credit: image_credit
        }.merge({
          is_portrait: image.image_size[:height] >= image.image_size[:width],
          is_landscape: image.image_size[:height] < image.image_size[:width]
        })
      end
    end
  end
end
