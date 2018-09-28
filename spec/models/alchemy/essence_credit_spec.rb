# frozen_string_literal: true

RSpec.describe Alchemy::EssenceCredit do
  let(:subject) { described_class.new }

  before do
    subject.url = 'https://europeana.eu/portal/record/123/abc'
  end

  it { should delegate_method(:annotation_target_uri).to(:europeana_record) }

  describe '#license' do
    context 'when the license is a known key' do
      before do
        subject.license = 'CC_BY'
      end

      it 'should return the license' do
        expect(subject.license).to eq('CC_BY')
      end
    end

    context 'when the license key is unknown' do
      before do
        subject.license = 'some rubbish'
      end

      it 'should return the license' do
        expect(subject.license).to eq('CNE')
      end
    end
  end

  describe '#europeana_record' do
    before do
      allow(Europeana::Record).to receive(:new) { 'New Record' }
      allow(subject).to receive(:europeana_record_id) { '/123/abc' }
    end

    it 'should instantiate a new Europeana::Record' do
      expect(subject.europeana_record).to eq('New Record')
    end

    context 'when the instance variable was set previously' do
      before do
        subject.instance_variable_set(:@europeana_record, 'Dummy Record')
      end

      it 'should use the instance variable' do
        expect(Europeana::Record).to_not receive(:new)
        expect(subject.europeana_record).to eq('Dummy Record')
      end
    end
  end

  describe '#europeana_record_id' do
    before do
      allow(Europeana::Record).to receive(:id_from_portal_url) { '/123/abc' }
    end

    it 'should return the id of the url' do
      expect(subject.europeana_record_id).to eq('/123/abc')
    end

    context 'when the instance variable was set previously' do
      before do
        subject.instance_variable_set(:@europeana_record_id, 'Dummy ID')
      end

      it 'should use the instance variable' do
        expect(Europeana::Record).to_not receive(:id_from_portal_url)
        expect(subject.europeana_record_id).to eq('Dummy ID')
      end
    end
  end

  describe '#has_annotation_target?' do
    context 'when there is no europeana record associated' do
      before do
        subject.instance_variable_set(:@europeana_record_id, nil)
      end

      it 'should be false' do
        expect(subject.has_annotation_target?).to_not be_truthy
      end
    end

    context 'when there is no europeana record associated' do
      before do
        subject.instance_variable_set(:@europeana_record_id, '/123/abc')
      end

      it 'should be true' do
        expect(subject.has_annotation_target?).to be_truthy
      end
    end
  end

  context 'for a credit in a child page' do
    let(:subject) { alchemy_essence_credits(:portrait_image_essence_credit) }

    describe '#annotation' do
      let(:subject) { alchemy_essence_credits(:portrait_image_essence_credit) }

      it 'should instantiate a new Europeana::Annotation' do
        expect(subject.annotation).to be_a(Europeana::Annotation)
      end

      context 'when the instance variable was set previously' do
        before do
          subject.instance_variable_set(:@annotation, 'Dummy Annotation')
        end

        it 'should use the instance variable' do
          expect(Europeana::Annotation).to_not receive(:new)
          expect(subject.annotation).to eq('Dummy Annotation')
        end
      end
    end

    describe '#annotation_target' do
      it 'should be a hash containing a properly formated annotation target' do
        target = subject.annotation_target
        expect(target).to be_a(Hash)
        expect(target).to have_key(:'type')
        expect(target).to have_key(:'scope')
        expect(target).to have_key(:'source')
      end
    end

    describe '#annotation_attributes' do
      it 'should be a hash containing properly formated annotation attributes' do
        attributes = subject.annotation_attributes
        expect(attributes).to be_a(Hash)
        expect(attributes).to have_key(:motivation)
        expect(attributes).to have_key(:body)
        expect(attributes).to have_key(:target)
      end
    end

    describe '#annotation_link_resource_uri' do
      it 'should be the url of the exhibition' do
        expect(subject.annotation_link_resource_uri).to include(alchemy_pages(:complex_exhibition_root).urlname)
      end
    end
  end
end