# frozen_string_literal: true

RSpec.describe Alchemy::PagesController do
  describe 'GET render_page' do

    # Use the show page
    let(:action) { proc { get(:show, format: format, urlname: page.urlname, locale: page.language_code) } }
    let(:format) { 'html' }
    let(:page) { alchemy_pages(:german_music_page) }

    before { action.call }
    subject { response }

    context 'when the format is html' do
      it { is_expected.to have_http_status(200) }
    end

    context 'when the format is json' do
      let(:format) { 'json' }
      it { is_expected.to have_http_status(200) }
    end

    context 'when the format is rss' do
      let(:format) { 'rss' }

      ##
      # No Europeana Exhibition pages contain feeds
      # context 'when the page contains a feed' do
      #  it { is_expected.to have_http_status(200) }
      # end

      context 'when the page does NOT contain a feed' do
        it { is_expected.to have_http_status(404) }
      end
    end
  end
end