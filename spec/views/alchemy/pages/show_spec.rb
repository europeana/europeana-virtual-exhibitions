RSpec.describe 'alchemy/pages/show.html.mustache' do
  context 'when page has multiple languages' do
    let(:pages) do
      pages = {}.tap do |hash|
        %w(de en fr).each do |lang_code|
          # en exists by `Alchemy::Seeder.seed!` in rails_helper.rb
          lang = Alchemy::Language.find_by_code(lang_code) ||
            create(:alchemy_language, name: lang_code.upcase, code: lang_code)
          hash[lang_code] = create(:alchemy_page, public: true, visible: true, name: 'sample', page_layout: 'exhibition_theme_page', language: lang)
        end
      end
    end

    it 'should have language switching links' do
      assign(:page, pages['en'])
      render
      (pages.keys - ['en']).each do |locale|
        expect(rendered).to have_selector(%Q(ul#settings-menu li a[href$="/#{locale}/exhibitions/sample"]))
      end
    end

    it 'should have default language meta link' do
      assign(:page, pages['en'])
      render
      expect(rendered).to have_selector('link[hreflang="x-default"][rel="alternate"][href="http://test.host/exhibitions/sample"]', visible: false)
    end

    it 'should have alternate language meta links' do
      assign(:page, pages['en'])
      render
      pages.keys.each do |locale|
        expect(rendered).to have_selector(%Q(link[hreflang="#{locale}"][rel="alternate"][href="http://test.host/#{locale}/exhibitions/sample"]), visible: false)
      end
    end
  end
end
