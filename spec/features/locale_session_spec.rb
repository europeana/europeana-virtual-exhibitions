RSpec.feature 'Locale stored in session' do
  describe 'session' do
    it 'stores the locale' do
      fr_language = create(:alchemy_language, name: 'French', code: "fr")
      create(:alchemy_page, public: true, visible: true, name: 'sample', page_layout: 'exhibition_theme_page', language: fr_language)
      visit '/fr/exhibitions/sample'
      visit '/exhibitions/sample'
      expect(current_path).to eq('/fr/exhibitions/sample')
    end
  end
end
