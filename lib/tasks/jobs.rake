namespace :jobs do
  namespace :cache do
    desc 'Queue Cache::Feed jobs (blogs / exhibitions / Custom)'
    task feeds: :environment do
      Feed.top_nav_feeds('en').each do |_feed, url|
        Europeana::Feeds::FetchJob.perform_later(url)
      end
    end
  end
end
