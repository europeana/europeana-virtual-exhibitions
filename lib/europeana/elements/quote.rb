module Europeana
  module Elements
    class Quote < Europeana::Elements::Base
      protected
      def data
        {
          quote: @element.content_by_name("quote").essence.body,
          stripped_quote: @element.content_by_name("quote").essence.stripped_body,
          quotee: @element.content_by_name("quotee").essence.body
        }
      end
    end
  end
end
