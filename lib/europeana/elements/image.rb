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
          is_portrait: image.portrait_format?,
          is_landscape: image.landscape_format?
        })
      end
    end
  end
end
