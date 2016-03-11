module Europeana
  module Mixins
    module ImageCredit
      def image_credit(name = 'image_credit')
        {
          attribution_title: @element.content_by_name(name).essence.title,
          attribution_creator: @element.content_by_name(name).essence.author,
          attribution_institution: @element.content_by_name(name).essence.institution,
          attribution_url: @element.content_by_name(name).essence.url,
          license_public: true
        }
      end
    end
  end
end
