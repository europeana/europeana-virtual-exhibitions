module Europeana
  module Mixins
    module ImageCredit
      LICENSES = {
        'Public Domain Mark' => 'public',
        'CC0' => 'CC0',
        'CC BY' => 'CC_BY',
        'CC BY-SA' => 'CC_BY_SA',
        'CC BY-ND' => 'CC_BY_ND',
        'CC BY-NC' => 'CC_BY_NC',
        'CC BY-NC-SA' => 'CC_BY_NC_SA',
        'CC BY-NC-ND' => 'CC_BY_NC_ND',
        'In Copyright - EU Orphan Work' => 'RS_INC_OW_EU',
        'In Copyright - Educational Use Permitted' => 'RS_INC_EDU',
        'In Copyright' => 'RS_INC',
        'No Copyright - Non-Commercial Use Only' => 'RS_NOC_NC',
        'No Copyright - Other Known Legal Restrictions' => 'RS_NOC_OKLR',
        'Copyright Not Evaluated' => 'RS_CNE',
      }

      LICENSES_URL = {
        'public' => 'https://creativecommons.org/publicdomain/mark/1.0/',
        'CC0' => 'https://creativecommons.org/publicdomain/zero/1.0/',
        'CC_BY' => 'https://creativecommons.org/licenses/by/1.0',
        'CC_BY_SA' => 'https://creativecommons.org/licenses/by-sa/1.0',
        'CC_BY_ND' => 'https://creativecommons.org/licenses/by-nc-nd/1.0',
        'CC_BY_NC' => 'https://creativecommons.org/licenses/by-nc/1.0',
        'CC_BY_NC_SA' => 'https://creativecommons.org/licenses/by-nc-sa/1.0',
        'CC_BY_NC_ND' => 'https://creativecommons.org/licenses/by-nc-nd/1.0',
        'RS_INC_EDU' => 'http://rightsstatements.org/vocab/InC-EDU/1.0/',
        'RS_NOC_OKLR' => 'http://rightsstatements.org/vocab/NoC-OKLR/1.0/',
        'RS_INC' => 'http://rightsstatements.org/vocab/InC/1.0/',
        'RS_NOC_NC' => 'http://rightsstatements.org/vocab/NoC-NC/1.0/',
        'RS_INC_OW_EU' => 'http://rightsstatements.org/vocab/InC-OW-EU/1.0/',
        'RS_CNE' => 'http://rightsstatements.org/vocab/CNE/1.0/'
      }

      def image_credit(name = 'image_credit')
        credit = @element.content_by_name(name)
        return false if credit.nil?
        country = ISO3166::Country[credit.essence.country_code]
        {
          attribution_title: credit.essence.title,
          attribution_creator: credit.essence.author,
          attribution_institution: credit.essence.institution,
          attribution_url: attribution_url(credit),
          caption: caption(name),
          stripped_caption: stripped_caption(name),
          license_url: license_link(credit),
          license_code: credit.essence.license,
          license_text: license_label(credit),
          country_code: credit.essence.country_code,
          country: country.nil? ? false : (country.translations[::I18n.locale.to_s] || country.name)
        }.merge("license_#{credit.essence.license}" => true)
      end

      def caption(name = 'image_credit')
        credit = @element.content_by_name(name)
        return false if credit.nil?
        "<a href='#{credit.essence.url}'>#{credit.essence.title}</a>, #{credit.essence.author}, #{credit.essence.institution}, <a href='#{license_link(credit)}'>#{license_label(credit)}</a>"
      end

      def license_label(credit)
        inverted = Europeana::Mixins::ImageCredit::LICENSES.invert

        return inverted[credit.essence.license] if inverted.key?(credit.essence.license)
        'Copyright Not Evaluated'
      end

      def attribution_url(credit)
        credit.essence.url.blank? ? false : credit.essence.url
      end

      def license_link(credit)
        url = Europeana::Mixins::ImageCredit::LICENSES_URL[credit.essence.license]
        url
      end

      def stripped_caption(name = 'image_credit')
        return false if caption(name) == false
        strip_tags(caption(name))
      end


      def strip_tags(html)
        return html if html.blank?
        if html.index('<')
          text = ''
          tokenizer = ::HTML::Tokenizer.new(html)
          while token = tokenizer.next
            node = ::HTML::Node.parse(nil, 0, 0, token, false)
            # result is only the content of any Text nodes
            text << node.to_s if node.class == ::HTML::Text
          end
          # strip any comments, and if they have a newline at the end (ie. line with
          # only a comment) strip that too
          text.gsub(/<!--(.*?)-->[\n]?/m, '')
        else
          html # already plain text
        end
      end
    end
  end
end
