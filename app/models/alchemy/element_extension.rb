# frozen_string_literal: true

Alchemy::Element.module_exec do
  # Overriding the touchable_pages relationship
  has_many :touchable_pages, class_name: 'Alchemy::Page', foreign_key: 'id', primary_key: 'page_id'

  after_commit :flush_cache
  def flush_cache
    Europeana::PageCacheJob.perform_later page.id if page
  end
end
