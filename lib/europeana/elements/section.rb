module Europeana
  module Elements
    class Section < Europeana::Elements::Base
      def data
        {
          section_title: get(:title, :body)
        }
      end
    end
  end
end
