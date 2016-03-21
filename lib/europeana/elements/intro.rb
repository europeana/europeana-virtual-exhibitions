module Europeana
  module Elements
    class Intro < Europeana::Elements::Base
      include Europeana::Mixins::ImageVersion
      include Europeana::Mixins::ImageCredit

      def body
        @element.content_by_name("body").essence.body
      end

      def stripped_body
        @element.content_by_name("body").essence.stripped_body
      end

      protected
      def data
        {
          intro_description: body,
          stripped_intro_description: stripped_body,
          image: versions,
          title: @element.content_by_name("title").essence.body,
          sub_title: @element.content_by_name("sub_title").essence.body,
          image_credit: image_credit,
          label:  @element.content_by_name("label").essence.body,
          partner_image: versions("partner_logo")
        }
      end
    end
  end
end
