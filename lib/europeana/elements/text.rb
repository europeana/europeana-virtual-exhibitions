module Europeana
  module Elements
    class Text < Europeana::Elements::Base
      protected

      def data
        {
          body: get(:body, :body),
          stripped_body: get(:body, :stripped_body)
        }
      end
    end
  end
end
