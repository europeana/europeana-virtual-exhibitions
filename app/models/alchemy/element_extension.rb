Alchemy::Element.module_exec do
  after_commit :flush_cache
  def flush_cache
    Europeana::PageCacheJob.perform_later page.id if page
  end
end
