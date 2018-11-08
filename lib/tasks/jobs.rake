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

  namespace :annotations do
    desc 'Annotate Europeana records which are referenced in credits elements of exhibitions'
    task store: :environment do
      Alchemy::Page.published.where(depth: 2).each do |exhibition|
        Europeana::StoreAnnotationsJob.perform_later(exhibition.urlname, exhibition.language_code)
      end
    end
  end
end
