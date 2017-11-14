# frozen_string_literal: true

require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

unless ENV['DISABLE_SCHEDULED_JOBS']
  every(1.hour, 'cache.feeds') do
    Feed.top_nav_feeds('en').each do |_feed, url|
      Europeana::Feeds::FetchJob.perform_later(url)
    end
  end
end