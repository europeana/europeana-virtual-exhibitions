# frozen_string_literal: true
module Alchemy
  describe 'Show' do
    let(:basic_exhibition_page) do
      alchemy_pages(:exhibition_page)
    end

    describe '#elements' do
      context 'page with only one element' do
        before do
          basic_exhibition_page.elements << alchemy_elements(:text_element)
        end

        let(:page) { Europeana::Page.new(basic_exhibition_page)}

        it 'has set is_full_section_element to true' do
          expect(page.elements[:items].first[:is_full_section_element]).to eq(true)
        end
      end

      context 'page with two elements' do
        before do
          basic_exhibition_page.elements << alchemy_elements(:text_element)
          basic_exhibition_page.elements << alchemy_elements(:quote_element)
        end

        let(:page) { Europeana::Page.new(basic_exhibition_page) }

        it 'has set is_full_section_element to false' do
          expect(page.elements[:items].first[:is_full_section_element]).to eq(false)
        end
      end
    end

    describe '#meta_tags' do
      let(:page) { Europeana::Page.new(page_record) }

      context 'public page' do
        let(:page_record) { alchemy_pages(:exhibition_page) }

        it 'should have meta tags that allow indexing' do
          expect(page.meta_tags).to eq(meta_name: 'robots', content: 'index,follow')
        end
      end

      context 'non public page' do
        let(:page_record) { alchemy_pages(:restricted_page) }

        it 'should have meta tags that do not allow indexing' do
          expect(page.meta_tags).to eq(meta_name: 'robots', content: 'noindex,nofollow')
        end
      end
    end

    describe '#link_tags' do
      let(:english_alchemy_page) { alchemy_pages(:english_music_page) }
      let(:german_alchemy_page) { alchemy_pages(:german_music_page) }
      let!(:english_page) { Europeana::Page.new(english_alchemy_page) }
      let!(:german_page) { Europeana::Page.new(german_alchemy_page) }
      it 'show right alternatives for german and english pages' do
        expect(english_page.link_tags.detect { |tag| tag[:hreflang] == 'de' }).not_to be_nil
        expect(english_page.link_tags.detect { |tag| tag[:href].include?('/de/exhibitions/music-exhibition') }).not_to be_nil
        expect(german_page.link_tags.detect { |tag| tag[:hreflang] == 'en' }).not_to be_nil
        expect(german_page.link_tags.detect { |tag| tag[:href].include?('/en/exhibitions/music-exhibition') }).not_to be_nil
      end
    end

    describe '#thumbnail' do
      context 'elements assigned' do
        it 'should return nil' do
          expect(Europeana::Page::new(basic_exhibition_page).thumbnail).to eq(false)
        end
      end

      context 'image element assigned' do
        let(:exhibition_with_elements) do
          page = alchemy_pages(:exhibition_page)
          page.elements << alchemy_elements(:image_element)
          page
        end

        it 'should not return nil' do
          expect(Europeana::Page::new(exhibition_with_elements).thumbnail).not_to eq(nil)
        end
      end
    end

    describe '#breadcrumbs' do
      let(:page_record) { alchemy_pages(:exhibition_page) }
      let(:breadcrumbs) { Europeana::Page.new(page_record).breadcrumbs }

      it 'should have breadcrumbs back to the portal, the index and itself' do
        expect(breadcrumbs.count).to eq(3)
        expect(breadcrumbs[0][:url]).to include('portal')
        expect(breadcrumbs[0][:title]).to include('Zurück zur Startseite')
        expect(breadcrumbs[0][:is_first]).to eq(true)
        expect(breadcrumbs[1][:url]).to include('/de/exhibitions/startseite')
        expect(breadcrumbs[1][:title]).to include('Ausstellungen')
        expect(breadcrumbs[2][:url]).to include('/de/exhibitions/page-1')
        expect(breadcrumbs[2][:title]).to include('Page 1')
        expect(breadcrumbs[2][:is_last]).to eq(true)
      end
    end

    context 'complex exhibition' do
      let(:exhibition_root_page) do
        alchemy_pages(:complex_exhibition_root)
      end

      let(:exhibition_child_page_1) do
        alchemy_pages(:complex_exhibition_child)
      end

      let(:child_page) { Europeana::Page.new(exhibition_child_page_1) }

      describe '#exhibition' do
        context 'child page' do
          it 'is equal to root of exhibition' do
            expect(child_page.exhibition).to eq(exhibition_root_page)
          end
        end
        context 'root page' do
          it 'is equal to itself' do
            expect(Europeana::Page.new(exhibition_root_page).exhibition).to eq(exhibition_root_page)
          end
        end
      end

      describe '#breadcrumbs' do
        let(:breadcrumbs) { child_page.breadcrumbs }

        it "should have breadcrumbs back to the portal, the index, it's parent and itself" do
          expect(breadcrumbs.count).to eq(4)
          expect(breadcrumbs[0][:url]).to include('portal')
          expect(breadcrumbs[0][:title]).to include('Zurück zur Startseite')
          expect(breadcrumbs[0][:is_first]).to eq(true)
          expect(breadcrumbs[1][:url]).to include('/de/exhibitions/startseite')
          expect(breadcrumbs[1][:title]).to include('Ausstellungen')
          expect(breadcrumbs[2][:url]).to match(%r{de\/exhibitions\/exhibition-root})
          expect(breadcrumbs[2][:title]).to match(/Exhibition root/)
          expect(breadcrumbs[3][:url]).to match(%r{de\/exhibitions\/exhibition-root\/exhibition-child})
          expect(breadcrumbs[3][:title]).to match(/Exhibition child/)
          expect(breadcrumbs[3][:is_last]).to eq(true)
        end
      end
    end
  end
end
