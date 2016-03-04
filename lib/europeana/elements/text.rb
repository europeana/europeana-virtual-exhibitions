module Europeana
  module Elements
    class Text < Europeana::Elements::Base
      def body
        @element.content_by_name("body").essence.body
      end

      def stripped_body
        @element.content_by_name("body").essence.stripped_body
      end

      protected
      def data
        {
          body: body,
          stripped_body: stripped_body
        }
      end
    end
  end
end
