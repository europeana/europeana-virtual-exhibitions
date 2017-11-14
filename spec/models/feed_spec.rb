# frozen_string_literal: true

RSpec.describe Feed do
  describe 'top_nav_feeds' do
    subject = described_class.top_nav_feeds('en')
    it 'should contain URLs for blog, collections and galleries' do
      expect(subject).to be_a(Hash)
      expect(subject).to include(:blog, :collections, :galleries)
    end
  end
end