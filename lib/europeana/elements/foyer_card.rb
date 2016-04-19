module Europeana
  module Elements
    class FoyerCard < Europeana::Elements::Base
      include Europeana::Mixins::ImageVersion

      def data
        {
          state_1_label: get(:state_1_label, :body),
          state_1_title: get(:state_1_title, :body),
          state_1_image: versions('state_1_image'),
          state_1_link: url: get(:url, :link),
          state_2_title: get(:state_2_title, :body),
          state_2_body: get(:state_2_body, :body),
          state_2_image: get(:state_2_image, :picture) ? versions('state_2_image') : versions('state_1_image'),
          state_3_logo: versions('state_3_logo'),
          state_3_image: get(:state_3_image, :picture) ? versions('state_3_image') : versions('state_1_image'),
          state_2: get(:state_2_image, :picture) ? true : false,
          url: get(:url, :link)
        }
      end
    end
  end
end
