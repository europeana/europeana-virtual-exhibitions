# frozen_string_literal: true
RSpec.describe 'alchemy/pages/show.json.mustache' do

  let(:locale_code) { 'en' }
  let(:page) { alchemy_pages(:language_root_page_en) }

  before do
    I18n.locale = locale_code
    assign(:page, page)
    render
  end

  subject { JSON.parse(rendered) }

  it { is_expected.to have_key('url') }
  it { is_expected.to have_key('credit_image') }
  it { is_expected.to have_key('description') }
  it { is_expected.to have_key('full_image') }
  it { is_expected.to have_key('card_image') }
  it { is_expected.to have_key('card_text') }
  it { is_expected.to have_key('labels') }
  it { is_expected.to have_key('lang_code') }
  it { is_expected.to have_key('title') }
  it { is_expected.to have_key('slug') }
  it { is_expected.to have_key('depth') }

  context 'when it is a foyer page' do
    it 'should have the url' do
      expect(subject['url']).to eq('http://test.host/en/exhibitions/startseite')
    end

    it 'should have the title' do
      expect(subject['title']).to eq('Foyer')
    end

    it 'should have the description' do
      expect(subject['description']).to eq('Foyer')
    end

    it 'should not have images' do
      expect(subject['credit_image']).to be_nil
      expect(subject['full_image']).to be_nil
      expect(subject['card_image']).to be_nil
    end

    context 'when it is another language' do
      let(:locale_code) { 'de' }
      let(:page) { alchemy_pages(:language_root_page_de) }

      it 'should have the translated description' do
        expect(subject['description']).to eq('Startseite')
      end

      it 'should have the translated title' do
        expect(subject['title']).to eq('Startseite')
      end
    end
  end

  context 'when it is a exhibition root page' do
    let(:locale_code) { 'de' }
    let(:page) { alchemy_pages(:complex_exhibition_root) }

    it 'should have the url' do
      expect(subject['url']).to eq('http://test.host/de/exhibitions/exhibition-root')
    end

    it 'should have the title' do
      expect(subject['title']).to eq('Exhibition root')
    end

    it 'should have the description' do
      expect(subject['description']).to eq('Exhibition root')
    end

    it 'should have the card_text' do
      expect(subject['card_text']).to eq('Exhibition root')
    end

    it 'should have the slug' do
      expect(subject['slug']).to eq('exhibition-root')
    end

    it 'should have images' do
      expect(subject['credit_image']).not_to be_nil
      expect(subject['full_image']).not_to be_nil
      expect(subject['card_image']).not_to be_nil
    end

    context 'when the main image has "tags"' do
      it 'should have labels' do
        expect(subject['labels'].count).to be_positive
      end
    end
  end

  context 'when it is an exhibition child page' do
    let(:locale_code) { 'de' }
    let(:page) { alchemy_pages(:complex_exhibition_root) }

  end
end
