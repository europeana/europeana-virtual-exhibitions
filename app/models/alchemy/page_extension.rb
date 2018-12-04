# frozen_string_literal: true

Alchemy::Page.module_exec do
  include Alchemy::Page::Annotations

  after_commit :flush_cache

  def flush_cache
    Europeana::PageCacheJob.perform_later id
  end

  def exhibition
    @exhibition ||= exhibition? ? self : self_and_ancestors.detect { |page| page.depth == 2 }
  end

  def exhibition?
    depth == 2
  end

  def public?
    return false if public_on.blank?
    public_on <= Time.current && (public_until.blank? || public_until >= Time.current)
  end

  def credits
    credit_type = " AND alchemy_contents.essence_type='Alchemy::EssenceCredit'"
    credit_contents_join = "LEFT JOIN alchemy_contents ON alchemy_contents.essence_id = alchemy_essence_credits.id #{credit_type}"
    content_elements_join = 'LEFT JOIN alchemy_elements ON alchemy_elements.id = alchemy_contents.element_id'
    Alchemy::EssenceCredit.joins(credit_contents_join).joins(content_elements_join).
      where(alchemy_elements: { page_id: id })
  end
end
