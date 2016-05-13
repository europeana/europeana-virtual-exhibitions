module Europeana
  module Elements
    class ImageCompare < Europeana::Elements::Base
      include Europeana::Mixins::ImageVersion

      def data
        {
          image_1: versions(:image_1),
          image_2: versions(:image_2)
        }
      end
    end
  end
end
