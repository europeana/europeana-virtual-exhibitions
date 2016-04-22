module Europeana
  module Elements
    class Navigation < Europeana::Elements::Base
      protected

      def data
        {
          previous: {
            title: get(:previous, :link_title) ? get(:previous, :link_title) : false,
            url: get(:previous, :link) ? get(:previous, :link) : false
          },
          next: {
            title: get(:next, :link_title) ? get(:next, :link_title) : false,
            url: get(:next, :link) ? get(:next, :link) : false
          }
        }
      end
    end
  end
end
