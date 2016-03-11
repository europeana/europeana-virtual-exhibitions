module Europeana
  module Elements
    class Intro < Europeana::Elements::Base
      include Europeana::Mixins::ImageVersion

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
          image_credit: 
            {
              attribution_title: @element.content_by_name('image_credit').essence.body,
              attribution_creator: 'HARDCODED',
              attribution_institution: 'HARDCODED',
              attribution_url: 'http://HARDCODED.EU',
              license_public: true
            }
        }
      end
    end
  end
end
