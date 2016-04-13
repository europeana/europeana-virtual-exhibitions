module Europeana
  module Elements
    class RichImage < Europeana::Elements::Image

      def quote
        get(:quote, :body)
      end

      def quotee
        get(:quotee, :body)
      end

      def title
        get(:title, :body)
      end

      def sub_title
        get(:sub_title, :body)
      end

      def body
        get(:body, :body)
      end

      def stripped_body
        get(:body, :stripped_body)
      end


      protected
      def data
        {
          title: title.present? ? title : false,
          sub_title: sub_title.present? ? sub_title : false,
          image: versions,
          is_align_image_right: get(:image_alignment, :value) ? get(:image_alignment, :value).downcase == 'right' : false,
          is_align_image_left: get(:image_alignment, :value) ? get(:image_alignment, :value).downcase == 'left' : false,
          caption: caption.present? ? caption : false,
          stripped_caption: caption.present? ? caption : false,
          quote: quote.present? ? quote : false,
          quotee: quotee.present? ? quotee : false,
          body: body.present? ? body : false,
          stripped_body: stripped_body.present? ? stripped_body : false
        }
      end
    end
  end
end
