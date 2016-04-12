module Europeana
  module Mixins
    module ImageCredit
      LICENSES = {
        "Public Domain Mark" => "public",
        "Out of copyright - non commercial re-use" => "OOC",
        "CCO" => "CC0",
        "CC BY" => "CC_BY",
        "CC BY-SA" => "CC_BY_SA",
        "CC BY-ND" => "CC_BY_ND",
        "CC BY-NC" => "CC_BY_NC",
        "CC BY-NC-SA" => "CC_BY_NC_SA",
        "CC BY-NC-ND" => "CC_BY_NC_ND",
        "Rights Reserved - Free Access" => "RR_free",
        "Rights Reserved - Paid Access" => "RR_paid",
        "Orphan Work" => "orphan",
        "Unknown" => "unknown"
      }
      def image_credit(name = 'image_credit')
        credit = @element.content_by_name('image_credit')
        return false if credit.nil?
        {
          attribution_title: credit.essence.title,
          attribution_creator: credit.essence.author,
          attribution_institution: credit.essence.institution,
          attribution_url: credit.essence.url,
          caption: caption,
          stripped_caption: stripped_caption,
        }.merge({ "license_#{credit.essence.license}" => true})


      end

      def caption
        credit = @element.content_by_name('image_credit')
        return false if credit.nil?
        "#{credit.essence.title}, #{credit.essence.author}, <a href='#{credit.essence.url}'>#{credit.essence.institution}</a>, #{license_label(credit)}"
      end

      def license_label(credit)
        inverted = Europeana::Mixins::ImageCredit::LICENSES.invert

        return inverted[credit.essence.license] if inverted.has_key?(credit.essence.license)
        "unknown"
      end

      def stripped_caption
        return false if caption == false
        strip_tags(caption)
      end


      def strip_tags(html)
        return html if html.blank?
        if html.index("<")
          text = ""
          tokenizer = ::HTML::Tokenizer.new(html)
          while token = tokenizer.next
            node = ::HTML::Node.parse(nil, 0, 0, token, false)
            # result is only the content of any Text nodes
            text << node.to_s if node.class == ::HTML::Text
          end
          # strip any comments, and if they have a newline at the end (ie. line with
          # only a comment) strip that too
          text.gsub(/<!--(.*?)-->[\n]?/m, "")
        else
          html # already plain text
        end
      end
    end
  end
end
