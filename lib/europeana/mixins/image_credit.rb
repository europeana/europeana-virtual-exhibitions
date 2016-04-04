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
          license_public: credit.essence.license,
          caption: caption,
          stripped_caption: stripped_caption
        }
      end

      def caption
        credit = @element.content_by_name('image_credit')
        return false if credit.nil?
        "#{credit.essence.title}, #{credit.essence.author}, <a href='#{credit.essence.url}'>#{credit.essence.institution}</a>, #{credit.essence.license}"
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
