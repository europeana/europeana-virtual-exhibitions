# frozen_string_literal: true
RSpec.feature 'Foyer page' do
  describe 'foyer page' do

    before do
      visit '/de/exhibitions/startseite'
    end
    [false, true].each do |js|
      context (js ? 'with JS' : 'without JS'), js: js do
        it 'has a footer with proper elements' do
          sleep 1 if js
          footer = page.all(:xpath, "//footer[contains(@class, 'footer') and contains(@class, 'v2')]").first
          expect(footer).to have_css('div.l-mission')
          expect(footer).to have_css('div.signup')
          expect(footer).to have_css('div.social-links')
        end
      end
    end
  end
end
