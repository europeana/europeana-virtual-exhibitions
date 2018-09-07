# frozen_string_literal: true

namespace :jobs do
  namespace :cache do
    desc 'Queue Cache::Feed jobs (blogs / exhibitions / Custom)'
    task feeds: :environment do
      Feed.top_nav_feeds('en').each_value do |url|
        Europeana::Feeds::FetchJob.perform_later(url)
      end
    end
  end

  namespace :picture do
    desc 'Enqueue picture versions jobs to generate Alchemy::PictureVersions'
    task version_jobs: :environment do
      Alchemy::Picture.find_each do |picture|
        Europeana::PictureVersionsJob.perform_later(picture.id)
      end
    end
  end
end
