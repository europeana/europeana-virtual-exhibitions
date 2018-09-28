# frozen_string_literal: true
RSpec.feature 'Feedback button' do
  describe 'feedback form' do
    context 'with JS', js: true do
      context 'with feedback post location configured' do
        before do
          Europeana::FeedbackButton.mail_to = 'feedback@example.com'
        end
        context 'on a foyer page' do
          it 'is present' do
            visit '/de/exhibitions/startseite'
            sleep 1
            expect(page).to have_css('#feedback-form')
          end
        end
        context 'on an exhibition page' do
          it 'is not present' do
            visit '/de/exhibitions/music-exhibition'
            sleep 1
            expect(page).to_not have_css('#feedback-form')
          end
        end
      end

      context 'without feedback post location configured' do
        before do
          Europeana::FeedbackButton.mail_to = nil
        end
        it 'is not present' do
          visit '/en/exhibitions/foyer'
          sleep 1
          expect(page).to_not have_css('#feedback-form')
        end
      end
    end

    # Feedback requires JavaScript so all these tests expect no button to exist.
    context 'without JS', js: false do
      context 'with feedback post location configured' do
        before do
          Europeana::FeedbackButton.mail_to = 'feedback@example.com'
        end
        context 'on a foyer page' do
          it 'is present' do
            visit '/de/exhibitions/startseite'
            expect(page).to_not have_css('#feedback-form')
          end
        end
        context 'on an exhibition page' do
          it 'is not present' do
            visit '/de/exhibitions/music-exhibition'
            expect(page).to_not have_css('#feedback-form')
          end
        end
      end

      context 'without feedback post location configured' do
        before do
          Europeana::FeedbackButton.mail_to = nil
        end
        it 'is not present' do
          visit '/en/exhibitions/foyer'
          expect(page).to_not have_css('#feedback-form')
        end
      end
    end
  end
end
