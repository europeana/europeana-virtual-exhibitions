# frozen_string_literal: true
RSpec.feature 'Locale stored in session' do
  describe 'session' do
    it 'stores the locale' do
      visit '/fr/exhibitions/sample'
      visit '/exhibitions/sample'
      expect(current_path).to eq('/fr/exhibitions/sample')
    end
  end
end
