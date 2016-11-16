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
        'In Copyright - EU Orphan Work' => 'INC-OW-EU',
        'In Copyright - Educational Use Permitted' => 'INC_EDU',
        'In Copyright' => 'INC',
        'No Copyright - Non-Commercial Use Only' => 'NOC_NC',
        'No Copyright - Other Known Legal Restrictions' => 'NOC_OKLR',
        'Copyright Not Evaluated' => 'CNE',
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
        'INC_EDU' => 'http://rightsstatements.org/vocab/InC-EDU/1.0/',
        'NOC_OKLR' => 'http://rightsstatements.org/vocab/NoC-OKLR/1.0/',

        # 'RR_free' and 'RR_paid' are the same as 'INC' but here for legacy data
        'RR_free' => 'http://rightsstatements.org/vocab/InC/1.0/',
        'RR_paid' => 'http://rightsstatements.org/vocab/InC/1.0/',
        'INC' => 'http://rightsstatements.org/vocab/InC/1.0/',

        # 'OOC' is the same as 'NOC-NC' but here for legacy data
        'OOC' => 'http://rightsstatements.org/vocab/NoC-NC/1.0/',
        'NOC-NC' => 'http://rightsstatements.org/vocab/NoC-NC/1.0/',

        # 'orphan' is the same as 'INC-OW-EU' but here for legacy data
        'orphan' => 'http://rightsstatements.org/vocab/InC-OW-EU/1.0/',
        'INC-OW-EU' => 'http://rightsstatements.org/vocab/InC-OW-EU/1.0/',

        # 'unknown' is the same as 'CNE' but here for legacy data
        'unknown' => 'http://rightsstatements.org/vocab/CNE/1.0/',
        'CNE' => 'http://rightsstatements.org/vocab/CNE/1.0/'
      }

      def image_credit(name = 'image_credit')
        credit = @element.content_by_name(name)
        return false if credit.nil?
        country = ISO3166::Country[credit.essence.country_code]
        {
          attribution_title: credit.essence.title,
          attribution_creator: credit.essence.author,
          attribution_institution: credit.essence.institution,
          attribution_url: credit.essence.url,
          caption: caption,
          stripped_caption: stripped_caption,
          license_url: license_link(credit),
          license_code: credit.essence.license,
          license_text: license_label(credit),
          country_code: credit.essence.country_code,
          country: country.nil? ? false : (country.translations[I18n.locale.to_s] || country.name)
        }.merge({ "license_#{credit.essence.license}" => true})
      end

      def caption
        credit = @element.content_by_name('image_credit')
        return false if credit.nil?
        "<a href='#{credit.essence.url}'>#{credit.essence.title}</a>, #{credit.essence.author}, #{credit.essence.institution}, <a href='#{license_link(credit)}'>#{license_label(credit)}</a>"
      end

      def license_label(credit)
        inverted = Europeana::Mixins::ImageCredit::LICENSES.invert

        return inverted[credit.essence.license] if inverted.has_key?(credit.essence.license)
        # Some legacy licences need to be looked up via the licence key of the license which has the same URL
        license_url = license_link(credit)
        Europeana::Mixins::ImageCredit::LICENSES_URL.select { |_key, url| url == license_url}.each do |key, _value|
          return inverted[key] if inverted.has_key?(key)
        end
        'Copyright Not Evaluated'
      end

      def license_link(credit)
        url = Europeana::Mixins::ImageCredit::LICENSES_URL[credit.essence.license]
        url
      end

      def stripped_caption
        return false if caption == false
        strip_tags(caption)
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
