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
          title: title.present? ? title : false,
          sub_title: sub_title.present? ? sub_title : false,
          image: versions,
          align_image_right: @element.content_by_name('image_alignment').essence.value.downcase == 'right',
          align_image_left: @element.content_by_name('image_alignment').essence.value.downcase == 'left',
          caption: caption.present? ? caption : false,
          quote: quote.present? ? quotee : false,
          quotee: quotee.present? ? quotee : false,
          body: body.present? ? body : false,
          stripped_body: stripped_body.present? ? stripped_body : false
        }
      end
    end
  end
end
