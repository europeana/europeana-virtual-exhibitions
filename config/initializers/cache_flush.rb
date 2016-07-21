Alchemy::Page.class_eval do
  after_commit :flush_cache
  def flush_cache
    Europeana::PageCacheJob.perform_later id
  end
end


Alchemy::Element.class_eval do
  after_commit :flush_cache
  def flush_cache
    Europeana::PageCacheJob.perform_later page.id if page
  end
end
