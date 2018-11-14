# frozen_string_literal: true

RSpec.describe Alchemy::Element do
  describe '#touch_pages' do
    subject { alchemy_elements(:exhibition_credit_element) }

    it 'should update the timestamps' do
      previous_updated = subject.page.updated_at
      subject.touch_pages
      page_after = subject.page.reload
      expect(page_after.updated_at).to_not eq(previous_updated)
    end
  end
end
