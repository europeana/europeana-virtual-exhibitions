module Europeana
  module Elements
    class Embed < Europeana::Elements::Base
      PROVIDERS =
      {
        youtube: ['www.youtube.com'],
        vimeo: ['player.vimeo.com']
      }

      def provider_info
        PROVIDERS.keys.collect do | p |
          { "is_#{p}_embed".to_sym => p == provider}
        end.reduce({}, :merge)
      end

      def data
        {
          provider: provider,
          direct_link: link,
          embed_link: embed_link,
          html: @element.content_by_name("embed").essence.source
        }.merge(provider_info)
      end

      def embed_link
        link
      end

      def link
        @link ||= @element.content_by_name("embed").essence.source.present? ? URI.extract(@element.content_by_name("embed").essence.source).first : ""
      end

      def parsed_url
        URI(link)
      end

      def provider
        mapping = PROVIDERS.map{|provider,domains| domains.map{|domain| { domain => provider }}}.flatten.reduce({}, :merge)

        if mapping.has_key?(parsed_url.host)
          return mapping[parsed_url.host]
        end
        nil
      end
    end
  end
end
