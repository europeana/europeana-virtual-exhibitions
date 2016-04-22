class Europeana::PageCacheJob < ActiveJob::Base
  queue_as :default

  def perform(id)
    page = Alchemy::Page.find(id)

    if page
      page = Europeana::Page.new(page)
      page.all_pages.each do |part|
        Rails.logger.info "Flushing cache for page #{part.id} / #{part.cache_key}"
        Rails.cache.delete(part.cache_key)
      end
    end
  end
end
