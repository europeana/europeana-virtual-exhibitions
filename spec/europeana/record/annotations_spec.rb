# frozen_string_literal: true

RSpec.describe Europeana::Record::Annotations do
  let(:including_class) do
    Class.new do
      include Europeana::Record::Annotations
      attr_accessor :id
    end
  end

  let(:instance_id) { '/abc/123' }

  let(:instance) do
    including_class.new.tap do |instance|
      instance.id = instance_id
    end
  end

  subject { instance }

  describe '#annotation_target_uri' do
    subject { instance.annotation_target_uri }

    it 'uses ID in data.europeana.eu URI' do
      expect(subject).to eq("http://data.europeana.eu/item#{instance_id}")
    end
  end
end
