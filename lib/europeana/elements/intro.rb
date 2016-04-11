module Europeana
  module Elements
    class Intro < Europeana::Elements::Base
      include Europeana::Mixins::ImageVersion
      include Europeana::Mixins::ImageCredit

      protected
      def data
        {
          intro_description: get(:body, :body),
          stripped_intro_description: get(:body, :stripped_body),
          image: versions,
          title: get(:title, :body),
          subtitle: get(:sub_title, :body),
          image_credit: image_credit,
          label: get(:label, :body),
          partner_image: versions("partner_logo")
        }
      end
    end
  end
end
