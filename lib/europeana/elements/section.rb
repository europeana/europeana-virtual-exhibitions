module Europeana
  module Elements
    class Section < Europeana::Elements::Base

      def data
        {
          section_title: @element.content_by_name('title').essence.body
        }
      end
    end
  end
end
