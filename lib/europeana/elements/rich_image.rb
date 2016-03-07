module Europeana
  module Elements
    class RichImage < Europeana::Elements::Image

      def quote
        @element.content_by_name('quote').essence.body
      end

      def quotee
        @element.content_by_name('quotee').essence.body
      end

      def title
        @element.content_by_name('title').essence.body
      end

      def sub_title
        @element.content_by_name('sub_title').essence.body
      end

      protected
      def data
        {
          title: title,
          sub_title: sub_title,
          image: versions,
          caption: caption,
          quote: quote,
          quotee: quotee
        }
      end
    end
  end
end
