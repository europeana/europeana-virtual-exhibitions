module Europeana
  module Elements
    class FoyerCard < Europeana::Elements::Base
      include Europeana::Mixins::ImageVersion
      include Europeana::Mixins::ImageCredit

      def caption
        @element.content_by_name('caption') ? @element.content_by_name('caption').essence.body : nil
      end


      def data
        {
          state_1_label: @element.content_by_name('state_1_label').essence.body,
          state_1_title: @element.content_by_name('state_1_title').essence.body,
          state_1_image: versions('state_1_image'),
          state_2_title: @element.content_by_name('state_2_title').essence.body,
          state_2_body: @element.content_by_name('state_2_body').essence.body,
          state_2_image: versions('state_2_image'),
          state_3_logo: versions('state_3_logo'),
          state_3_image: versions('state_3_image'),
          url: @element.content_by_name('url').essence.link
        }
      end
    end
  end
end
