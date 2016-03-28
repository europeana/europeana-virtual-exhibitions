module Europeana
  module Elements
    class Quote < Europeana::Elements::Base
      protected
      def data
        {
          quote: get(:quote, :body),
          stripped_quote: get(:quote, :stripped_body),
          quotee: get(:quotee, :body)
        }
      end
    end
  end
end
