require 'rails_helper'

module Alchemy
  describe 'Show' do
    let(:basic_exhibition_page) do
      create(:alchemy_page, :public, visible: true, name: 'Page 1', page_layout: 'exhibition_theme_page')
    end

    describe "#elements" do
      context 'page with only one element' do
        before do
          basic_exhibition_page.elements << create(:alchemy_element, name: 'text')
        end

        let(:page) { Europeana::Page.new(basic_exhibition_page)}

        it 'has set is_full_section_element to true' do
          expect(page.elements[:items].first[:is_full_section_element]).to eq(true)
        end
      end

      context 'page with two elements' do
        let(:basic_exhibition) do
          create(:alchemy_page, :public, visible: true, name: 'page with two elements', page_layout: 'exhibition_theme_page')
        end
        before do
          basic_exhibition.elements << create(:alchemy_element, create_contents_after_create: true, name: 'text')
          basic_exhibition.elements << create(:alchemy_element, name: 'quote', create_contents_after_create: true)
        end

        let(:page) { Europeana::Page.new(basic_exhibition)}

        it 'has set is_full_section_element to false' do
          expect(page.elements[:items].first[:is_full_section_element]).to eq(false)
        end
      end
    end

    describe "#meta_tags" do
      let(:page) { Europeana::Page.new(page_record)}

      context "public page" do
        let(:page_record) { create(:alchemy_page, :public)}

        it "should have meta tags that allow indexing" do
          expect(page.meta_tags).to eq({:meta_name=>"robots", :content=>"index,follow"})
        end
      end

      context "non public page" do
        let(:page_record) { create(:alchemy_page, :restricted, robot_index: false, robot_follow: false)}

        it "should have meta tags that do not allow indexing" do
          expect(page.meta_tags).to eq({:meta_name=>"robots", :content=>"noindex,nofollow"})
        end
      end
    end

    describe "#link_tags" do
      let(:language) { create(:alchemy_language)}
      let!(:root_page) {create(:alchemy_page, name: 'music exhibition', language_code: :en)}
      let!(:german_page) {create(:alchemy_page, :public, name: 'music exhibition', language_code: language.language_code)}
      it "show right alternatives for german and english pages" do
        expect(Europeana::Page.new(root_page).link_tags).to eq([{:rel=>"alternate", :hreflang=>"de", :href=>"http://#{ENV.fetch('CDN_HOST', ENV.fetch('APP_HOST', 'localhost'))}/portal/de/exhibitions/music-exhibition", :title=>nil}])
        expect(Europeana::Page.new(german_page).link_tags).to eq([])
      end
    end

    describe "#thumbnail" do
      context "elements assigned" do
        it "should return nil" do
          expect(Europeana::Page::new(basic_exhibition_page).thumbnail).to eq(false)
        end
      end

      context "image element assigned" do
        let(:exhibition_with_elements) do
          page = create(:alchemy_page)
          page.elements << create(:alchemy_element, name: 'image', create_contents_after_create: true)
          page
        end

        it "should not return nil" do
          expect(Europeana::Page::new(exhibition_with_elements).thumbnail).not_to eq(nil)
        end
      end
    end


    context "complex exhibition" do
      let(:exhibition_root_page) do
        create(:alchemy_page, :public)
      end

      let(:exhibition_child_page_1) do
        create(:alchemy_page, :public, parent_id: exhibition_root_page.id)
      end

      describe "#exhibition" do
        context "child page" do
          it "is equal to root of exhibition" do
            expect(Europeana::Page::new(exhibition_child_page_1).exhibition).to eq(exhibition_root_page)
          end
        end
        context "root page" do
          it "is equal to itself" do
            expect(Europeana::Page::new(exhibition_root_page).exhibition).to eq(exhibition_root_page)
          end
        end
      end

      describe "#chapter_elements" do
        context "when starting at root of exhibition" do
          it "outputs" do
            puts Europeana::Page::new(exhibition_child_page_1).thumbnail.inspect
          end
        end
      end

    end



  end
end
