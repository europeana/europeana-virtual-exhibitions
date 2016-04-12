module Europeana
  module Elements
    class ChapterThumbnail < Europeana::Elements::Base
      include Europeana::Mixins::ImageVersion

      def label
        # We use rescue since not all elements have a label essence
        get(:label, :body) rescue false
      end

      def data
        {
          image: versions,
          label: label
        }
      end
    end
  end
end
