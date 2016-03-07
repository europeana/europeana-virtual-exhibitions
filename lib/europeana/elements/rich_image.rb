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

      def body
        @element.content_by_name('body').essence.body
      end

      def stripped_body
        @element.content_by_name('body').essence.stripped_body
      end


      protected
      def data
        {
          title: title,
          sub_title: sub_title,
          image: versions,
          caption: caption,
          quote: quote,
          quotee: quotee,
          body: body,
          stripped_body: stripped_body
        }
      end
    end
  end
end
