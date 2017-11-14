# frozen_string_literal: true

##
# Defines the feeds used to populate the top nav, based on env vars for
# feed sources, like the Europeana Portal or Blog.
#
class Feed
  class << self
    ##
    # Returns the feeds that are used by the Exhibitions platform.
    #
    # @param language_code [String] two-character language code string
    def top_nav_feeds(language_code)
      {
        blog: blog_url,
        collections: portal_url + language_code + '/collections.rss',
        galleries: portal_url + language_code + '/explore/galleries.rss'
      }
    end

    def portal_url
      ENV['EUROPEANA_COLLECTIONS_URL'] || 'https://www.europeana.eu/portal/'
    end

    def blog_url
      ENV['EUROPEANA_BLOG_URL'] || 'http://blog.europeana.eu/feed/'
    end
  end
end
