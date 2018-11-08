# frozen_string_literal: true

RSpec.describe Alchemy::Page do
  let(:language_root_page_en) { alchemy_pages(:language_root_page_en) }
  let(:basic_exhibition_page) { alchemy_pages(:exhibition_page) }
  let(:exhibition_root_page) { alchemy_pages(:complex_exhibition_root) }
  let(:exhibition_child_page_1) { alchemy_pages(:complex_exhibition_child_one) }
  let(:exhibition_child_page_2) { alchemy_pages(:complex_exhibition_child_two) }

  it 'includes Annotations' do
    expect(described_class).to include(Alchemy::Page::Annotations)
  end

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

  describe '#exhibiiton?' do
    context 'when the page has a depth of 2' do
      let(:subject) { exhibition_root_page }
      it 'should return true' do
        expect(subject.exhibition?).to be_truthy
      end
    end

    context 'when the page is a foyer' do
      let(:subject) { language_root_page_en }
      it 'should return false' do
        expect(subject.exhibition?).to_not be_truthy
      end
    end

    context 'when it is a child page' do
      let(:subject) { exhibition_child_page_1 }
      it 'should return false' do
        expect(subject.exhibition?).to_not be_truthy
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

  describe '#public?' do
    subject { basic_exhibition_page }
    context 'when the exhibition is not public yet' do
      before do
        subject.public_on = DateTime.now + 2.days
      end

      it 'should be false' do
        expect(subject.public?).to_not be_truthy
      end
    end

    context 'when the exhibition has been published indefinitely' do
      before do
        subject.public_on = DateTime.now - 2.days
        subject.public_until = nil
      end

      it 'should be true' do
        expect(subject.public?).to be_truthy
      end
    end

    context 'when the exhibition is only currently published' do
      before do
        subject.public_on = DateTime.now - 2.days
        subject.public_until = DateTime.now + 1.days
      end

      it 'should be true' do
        expect(subject.public?).to be_truthy
      end
    end

    context 'when the exhibiton was published before' do
      before do
        subject.public_on = DateTime.now - 2.days
        subject.public_until = DateTime.now - 1.days
      end

      it 'should be false' do
        expect(subject.public?).to_not be_truthy
      end
    end
  end
end