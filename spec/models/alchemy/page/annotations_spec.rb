# frozen_string_literal: true

RSpec.describe Alchemy::Page::Annotations do
  include_context 'Annotations API'

  # Only Alchemy::Page includes Alchemy::Page::Annotations
  let(:including_class) { Alchemy::Page }
  let(:instance) { including_class.new }

  before do
    ENV['EUROPEANA_ANNOTATIONS_API_USER_NAME'] = 'Name With Spaces'
  end

  subject { instance }

  describe 'class methods' do
    describe '.annotate_records?' do
      subject { including_class.annotate_records? }

      context 'when a EUROPEANA_ANNOTATIONS_API_USER_TOKEN is provided' do
        before do
          ENV['EUROPEANA_ANNOTATIONS_API_USER_TOKEN'] = 'something'
        end

        it 'should be true' do
          expect(subject).to be_truthy
        end
      end

      context 'when NO EUROPEANA_ANNOTATIONS_API_USER_TOKEN is provided' do
        before do
          ENV['EUROPEANA_ANNOTATIONS_API_USER_TOKEN'] = nil
        end

        it 'should NOT be true' do
          expect(subject).to_not be_truthy
        end
      end
    end
  end

  describe '#annotations' do
    before do
      allow(Europeana::Annotation).to receive(:find) { 'Dummy annotation' }
    end

    it 'should return the found annotation' do
      expect(subject.annotations).to eq('Dummy annotation')
    end
  end

  describe '#annotation_search_params' do
    before do
      allow(subject).to receive(:annotation_link_resource_uri) { 'resource_uri' }
    end

    it 'should contain an array of qfs' do
      search_params = subject.annotations_search_params
      expect(search_params).to have_key(:qf)
      expect(search_params[:qf]).to include('creator_name:Name\ With\ Spaces')
      expect(search_params[:qf]).to include('link_relation:isGatheredInto')
      expect(search_params[:qf]).to include('motivation:linking')
      expect(search_params[:qf]).to include('link_resource_uri:"resource_uri"')
    end
  end

  describe '#annotation_link_resource_uri' do
    before do
      subject.language_code = 'en'
      subject.urlname = 'test-exhibit'
    end
    it 'should contain the host, language code and slug' do
      expect(subject.annotation_link_resource_uri).to eq('https://www.europeana.eu/portal/en/exhibitions/test-exhibit')
    end

  end

  describe '#annotation_link_resource_host' do
    before do
      ENV['ANNOTATION_LINK_RESOURCE_HOST'] = nil
      ENV['HTTP_HOST'] = nil
    end

    it 'should default to www.european.eu' do
      expect(subject.annotation_link_resource_host).to eq 'www.europeana.eu'
    end

    context 'when an ANNOTATION_LINK_RESOURCE_HOST is set' do
      before do
        ENV['ANNOTATION_LINK_RESOURCE_HOST'] = 'test-annotated-exhibitions.example'
      end

      it 'should use the annotation link resource host' do
        expect(subject.annotation_link_resource_host).to eq 'test-annotated-exhibitions.example'
      end
    end

    context 'when onlya HTTP_HOST is set' do
      before do
        ENV['HTTP_HOST'] = 'test-exhibitions.example'
      end

      it 'should use the http host' do
        expect(subject.annotation_link_resource_host).to eq 'test-exhibitions.example'
      end
    end
  end

  describe '#all_annotation_elements' do
    subject { alchemy_pages(:complex_exhibition_root).all_annotation_elements }
    it 'should map all EssenceCredits from all descendants which have annotation targets into an array' do
      expect(subject).to be_a(Array)
      expect(subject.count).to be_positive
      subject.each do |array_element|
        expect(array_element).to be_a(Alchemy::EssenceCredit)
        expect(array_element.url).to start_with('http://www.europeana.eu/portal/record')
      end
    end
  end

  describe '#needed_annotation_targets' do
    subject { alchemy_pages(:complex_exhibition_root).needed_annotation_targets }

    it 'should map annotation_elements to their respective targets' do
      expect(subject).to be_a(Array)
      expect(subject.count).to be_positive
      subject.each do |array_element|
        expect(array_element).to be_a(Hash)
        expect(array_element).to have_key(:scope)
        expect(array_element).to have_key(:source)
        expect(array_element).to have_key(:type)
      end
    end
  end

  describe '#needs_annotation_for_target?' do
    subject { alchemy_pages(:complex_exhibition_root).needs_annotation_for_target?(target) }
    context 'when the target is included in the needed targets' do
      let(:target) do
        {
          :scope=>"http://data.europeana.eu/item/123/abc",
          :source=>"https://test-exhibitions.example/portal/de/exhibitions/exhibition-root",
          :type=>"SpecificResource"
        }
      end

      it 'should be true' do
        expect(subject).to be_truthy
      end
    end

    context 'when the target is NOT included in the needed targets' do
      let(:target) do
        {
          :scope=>"http://data.europeana.eu/item/987/zyx",
          :source=>"https://test-exhibitions.example/portal/de/exhibitions/exhibition-test",
          :type=>"SpecificResource"
        }
      end

      it 'should be false' do
        expect(subject).to_not be_truthy
      end
    end
  end

  describe '#needs_annotation?' do
    let(:annotation) { double('dummy_annnotaion', target: { a: 'b', c: 'd'} ) }
    subject { alchemy_pages(:complex_exhibition_root) }

    it 'should call needs_annotation_for_target?' do
      expect(subject).to receive(:needs_annotation_for_target?).with(a: 'b', c: 'd')
      subject.needs_annotation?(annotation)
    end
  end

  describe '#existing_annotation_targets' do
    subject { alchemy_pages(:complex_exhibition_root).existing_annotation_targets }

    it 'should map all existing annotations' do
      expect(subject).to include({scope: "http://data.europeana.eu/item/abc/123", source: "http://media.example.com/item/123"})
    end
  end

  describe '#has_annotation_for_target?' do
    let(:target) do
      {
        :scope=>"http://data.europeana.eu/item/123/abc",
        :source=>"https://test-exhibitions.example/portal/de/exhibitions/exhibition-root",
        :type=>"SpecificResource"
      }
    end

    it 'should call annotation_target_included?' do
      expect(subject).to receive(:annotation_target_included?)
      expect(subject).to receive(:existing_annotation_targets) { [] }
      subject.has_annotation_for_target?(target)
    end
  end

  describe '#store_annotaitons' do
    context 'when the page is an exhibiton root' do
      subject { alchemy_pages(:complex_exhibition_root) }

      it 'should queue a StoreAnnotationsJob for itself' do
        expect{ subject.store_annotations }.to have_enqueued_job(Europeana::StoreAnnotationsJob).
          with(subject.urlname, subject.language_code)
      end
    end

    context 'when the page is a child page' do
      subject { alchemy_pages(:complex_exhibition_child_one) }

      it 'should queue a StoreAnnotationsJob for the parent exhibition' do
        expect{ subject.store_annotations }.to have_enqueued_job(Europeana::StoreAnnotationsJob).
          with(alchemy_pages(:complex_exhibition_root).urlname, subject.language_code)
      end
    end
  end

  describe '#destroy_annotations' do
    subject { alchemy_pages(:complex_exhibition_root) }

    it 'should queue a StoreAnnotationsJob with delete_all: true' do
      expect{ subject.destroy_annotations }.to have_enqueued_job(Europeana::StoreAnnotationsJob).
        with(subject.urlname, subject.language_code, delete_all: true)
    end
  end

  describe 'destroy_old_annotations' do
    subject { alchemy_pages(:complex_exhibition_root) }

    before do
      subject.urlname = 'a-new-slug'
    end

    it 'should queue a StoreAnnotationsJob with delete_all: true' do
      expect{ subject.destroy_old_annotations }.to have_enqueued_job(Europeana::StoreAnnotationsJob).
        with('exhibition-root', subject.language_code, delete_all: true)
    end
  end
  
  describe '#escape_annotation_query_value' do
    it 'should escape space characters with a forward slash' do
      expect(subject.send(:escape_annotation_query_value, 'With Space')).to eq('With\ Space')
    end
  end

  describe 'store_annotations_after_save?' do
    it 'returns true if the page is published and annotate records is true'
  end

  describe 'destroy_annotations_after_save?' do
    it 'returns true if the page is NOT published and annotate records is true'
  end

  describe '#destroy_annotations_before_save?' do
    it 'returns true if the page is NOT published has changed the urlname and annotate records is true'
  end

  describe '#annotation_target_included?' do
    it 'matches on source and scope'
  end
end