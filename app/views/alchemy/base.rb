module Alchemy
  class Base < Europeana::Styleguide::View
    include Europeana::FeedbackButton::FeedbackableView
    def cached_body
      lambda do |text|
        Rails.cache.fetch(cache_key, expires_in: 24.hours, force: force_cache) do
          render(text)
        end
      end
    end

    def head_links
      links = [ opensearch_link ]
      if params[:controller] == 'home' && params[:action] == 'index'
        links << { rel: 'canonical', href: root_url }
      end

      links = links + page_object.language_alternatives_tags
      links = links + page_object.language_default_link
      { items: links }
    end

    private

    def opensearch_link
      {
        rel: 'search', type: 'application/opensearchdescription+xml',
        href: Rails.application.config.x.europeana_opensearch_host + '/opensearch.xml',
        title: 'Europeana Search'
      }
    end

    def cache_version
      @cache_version ||= begin
        v = Rails.application.config.assets.version.dup
        unless Rails.application.config.x.cache_version.blank?
          v << ('-' + Rails.application.config.x.cache_version.dup)
        end
        v
      end
    end

    def cache_key
      keys = ['views', cache_version, locale.to_s, body_cache_key]
      keys.compact.join('/')
    end

    def force_cache
      !current_user.nil?
    end

    def page_object
      @page_object ||= Europeana::Page.new(@page)
    end
  end
end
