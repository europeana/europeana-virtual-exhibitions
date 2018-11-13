# frozen_string_literal: true

Alchemy::Touching.module_exec do
  # Overwriting the default 'touchable_pages.update_all(touchable_attributes)' functionality
  # in order to cause callbacks to trigger. See for example app/models/alchemy/page/annotations.rb
  def touch_pages
    return unless respond_to?(:touchable_pages)
    touchable_pages.each do |page|
      page.update(touchable_attributes)
    end
  end
end