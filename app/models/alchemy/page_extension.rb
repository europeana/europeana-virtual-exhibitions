# frozen_string_literal: true

Alchemy::Page.module_exec do
  include Alchemy::Page::Annotations

  after_commit :flush_cache

  def flush_cache
    Europeana::PageCacheJob.perform_later id
  end

  def exhibition
    @exhibition ||= depth == 2 ? self : self_and_ancestors.detect { |page| page.depth == 2 }
  end

  def credits
    credit_contents_join = "LEFT JOIN alchemy_contents ON alchemy_contents.essence_type='Alchemy::EssenceCredit' AND alchemy_contents.essence_id = alchemy_essence_credits.id"
    content_elements_join = "LEFT JOIN alchemy_elements ON alchemy_elements.id = alchemy_contents.element_id"
    Alchemy::EssenceCredit.joins(credit_contents_join).joins(content_elements_join).
      where(alchemy_elements: { page_id: self.id})
  end
end
