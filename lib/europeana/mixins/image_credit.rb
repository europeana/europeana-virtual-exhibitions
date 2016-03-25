module Europeana
  module Mixins
    module ImageCredit
      def image_credit(name = 'image_credit')
        credit = @element.content_by_name('image_credit')
        return false if credit.nil?
        {
          attribution_title: credit.essence.title,
          attribution_creator: credit.essence.author,
          attribution_institution: credit.essence.institution,
          attribution_url: credit.essence.url,
          license_public: credit.essence.license
        }
      end
    end
  end
end
