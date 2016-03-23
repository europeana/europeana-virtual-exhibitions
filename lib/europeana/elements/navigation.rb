module Europeana
  module Elements
    class Navigation < Europeana::Elements::Base
      protected
      def data
        {
          previous: {
            title: @element.content_by_name("previous").essence.link_title.present? ? @element.content_by_name("previous").essence.link_title : false,
            url: @element.content_by_name("previous").essence.link.present? ? @element.content_by_name("previous").essence.link : false
          },
          next: {
            title: @element.content_by_name("next").essence.link_title.present? ? @element.content_by_name("next").essence.link_title : false,
            url: @element.content_by_name("next").essence.link.present? ? @element.content_by_name("next").essence.link : false
          }
        }
      end
    end
  end
end
