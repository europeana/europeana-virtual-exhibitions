module Europeana
  module Elements
    class ImageCompare < Europeana::Elements::Base
      include Europeana::Mixins::ImageVersion
      include Europeana::Mixins::ImageCredit
      include Europeana::Mixins::HideInCredits

      def data
        {
          is_image_compare: true,
          image_1: versions(:image_1),
          image_1_credit: image_credit(:image_1_credit),
          image_2: versions(:image_2),
          image_2_credit: image_credit(:image_2_credit),
          # Normalised for credits
          image_compare_data: [
            {
              is_image_compare: true,
              caption: caption(:image_1_credit),
              stripped_caption: stripped_caption(:image_1_credit),
              image: versions(:image_1),
              image_credit: image_credit(:image_1_credit)
            },
            {
              is_image_compare: true,
              caption: caption(:image_2_credit),
              stripped_caption: stripped_caption(:image_2_credit),
              image: versions(:image_2),
              image_credit: image_credit(:image_2_credit)
            }
          ]
        }
      end
    end
  end
end
