module Europeana
  module Elements
    class CreditIntro < Europeana::Elements::Image

      def title
        get(:title, :body)
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
          image: versions,
          body: body.present? ? body : false,
          stripped_body: stripped_body.present? ? stripped_body : false
        }
      end
    end
  end
end
