module Europeana
  module Elements
    class ImageCompare < Europeana::Elements::Base
      include Europeana::Mixins::ImageVersion
      include Europeana::Mixins::ImageCredit

      def data
        {
          image_1: versions(:image_1),
          image_1_credit: image_credit(:image_1_credit),
          image_2: versions(:image_2),
          image_2_credit: image_credit(:image_2_credit)

        }
      end
    end
  end
end
