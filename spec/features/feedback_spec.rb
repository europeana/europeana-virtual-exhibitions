# frozen_string_literal: true
RSpec.feature 'Feedback button' do
  describe 'feedback form' do
    [false, true].each do |js|
      context (js ? 'with JS' : 'without JS'), js: js do
        context 'with feedback post location configured' do
          before do
            Rails.application.config.x.feedback_mail_to = 'feedback@example.com'
          end
          context 'on a foyer page' do
            it 'is present' do
              visit '/de/exhibitions/startseite'
              sleep 1 if js
              expect(page).to have_css('#feedback-form')
            end
          end
          context 'on an exhibition page' do
            it 'is not present' do
              visit '/de/exhibitions/music-exhibition'
              sleep 1 if js
              expect(page).to_not have_css('#feedback-form')
            end
          end
        end

        context 'without feedback post location configured' do
          before do
            Rails.application.config.x.feedback_mail_to = nil
          end
          it 'is not present' do
            visit '/en/exhibitions/startseite'
            sleep 1 if js
            expect(page).to_not have_css('#feedback-form')
          end
        end
      end
    end
  end
end
