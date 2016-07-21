module Europeana
  module Elements
    class Promo < Europeana::Elements::Base
      include Europeana::Mixins::ImageVersion

      protected
      def data
        {
          image: versions,
          button_text: get(:button_text, :body),
          text1: get(:text1, :body),
          text2: get(:text2, :body),
          link: get(:link, :link)
        }
      end
    end
  end
end
