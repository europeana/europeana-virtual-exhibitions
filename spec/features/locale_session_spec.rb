RSpec.feature 'Locale stored in session' do
  describe 'session' do
    it 'stores the locale' do
      create(:alchemy_page, public: true, visible: true, name: 'sample', page_layout: 'exhibition_theme_page', language_code: 'fr')
      visit '/fr/exhibitions/sample'
      visit '/exhibitions/sample'
      expect(current_path).to eq('/fr/exhibitions/sample')
    end
  end
end
