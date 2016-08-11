# frozen_string_literal: true
describe Europeana::Elements::Chapter do
  let(:element) { Alchemy::Element.create_from_scratch(name: 'chapter') }

  describe '#to_hash' do
    context 'new element' do
      let(:element) { Alchemy::Element.new_from_scratch(name: 'chapter') }

      it 'should not raise an error when outputting to an hash' do
        expect { Europeana::Elements::Base.build(element).to_hash }.to_not raise_error
      end
    end

    context 'persisted element' do
      it 'should not raise an error when outputting to an hash' do
        expect { Europeana::Elements::Base.build(element).to_hash }.to_not raise_error
      end
    end
  end

  describe 'attributes' do
    context 'element with no content' do
      let(:hash) { Europeana::Elements::Base.build(element).to_hash }

      attributes = %w(url title image)
      it 'should have the following attributes: ' + attributes.join(',') do
        attributes.each do |attribute|
          expect(hash).to have_key(attribute.to_sym)
        end
      end
    end
  end
end
