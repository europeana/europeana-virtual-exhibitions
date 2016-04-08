module Europeana
  module Elements
    class ChapterThumbnail < Europeana::Elements::Base
      include Europeana::Mixins::ImageVersion

      def data
        {
          image: versions,
          label: get(:label, :body)
        }
      end
    end
  end
end
