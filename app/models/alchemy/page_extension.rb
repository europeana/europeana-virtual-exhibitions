Alchemy::Page.module_exec do
  after_commit :flush_cache
  def flush_cache
    Europeana::PageCacheJob.perform_later id
  end
end