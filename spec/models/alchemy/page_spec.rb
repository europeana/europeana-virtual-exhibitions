# frozen_string_literal: true

RSpec.describe Alchemy::Page do
  let(:language_root_page_en) { alchemy_pages(:language_root_page_en) }
  let(:basic_exhibition_page) { alchemy_pages(:exhibition_page) }
  let(:exhibition_root_page) { alchemy_pages(:complex_exhibition_root) }
  let(:exhibition_child_page_1) { alchemy_pages(:complex_exhibition_child_one) }
  let(:exhibition_child_page_2) { alchemy_pages(:complex_exhibition_child_two) }

  describe '#exhibition' do
    context 'when the page is a child page' do
      let(:subject) { exhibition_child_page_1 }
      it 'should return the parent page' do
        expect(subject.exhibition).to eq(exhibition_root_page)
      end
    end

    context 'when the page is an exhibition root page' do
      let(:subject) { exhibition_root_page }
      it 'should return itself' do
        expect(subject.exhibition).to eq(exhibition_root_page)
      end
    end

    context 'when the page is a standalone root page' do
      let(:subject) { basic_exhibition_page }
      it 'should return itself' do
        expect(subject.exhibition).to eq(basic_exhibition_page)
      end
    end

    context 'when the page is a language root(foyer) page' do
      let(:subject) { language_root_page_en }
      it 'should return nothing' do
        expect(subject.exhibition).to be_nil
      end
    end
  end

  describe '#credits' do
    context 'when the page does not have any elements' do
      let(:subject) { basic_exhibition_page }
      it 'should return nil' do
        expect(subject.credits).to be_empty
      end
    end

    context 'when the page has credit elements' do
      let(:subject) { exhibition_root_page }
      it 'should return all the credit elements for itself' do
        subject.credits.each do |credit|
          expect(credit).to be_a(Alchemy::EssenceCredit)
        end
        expect(subject.credits).to_not include(alchemy_essence_credits(:landscape_image_essence_credit))
        expect(subject.credits).to include(alchemy_essence_credits(:image_essence_credit))
      end
    end
  end
end