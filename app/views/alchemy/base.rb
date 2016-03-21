module Alchemy
  class Base < Europeana::Styleguide::View

    def cached_body
      lambda do |text|
        Rails.cache.fetch(cache_key, expires_in: 24.hours, force: force_cache) do
          render(text)
        end
      end
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
  end
end
