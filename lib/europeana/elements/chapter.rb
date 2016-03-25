module Europeana
  module Elements
    class Chapter < Europeana::Elements::Base
      include Europeana::Mixins::ImageVersion

      def data
        {
          title: get(:link, :link_title),
          url: get(:link, :link),
          image: versions
        }
      end
    end
  end
end
