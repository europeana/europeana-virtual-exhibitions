require 'rails_helper'

module Europeana
  describe 'Elements' do
    describe 'Text' do
      let(:element) { Alchemy::Element.create_from_scratch(name: 'text') }

      describe '#to_hash' do
        context 'new element' do
          let(:element) { Alchemy::Element.new_from_scratch(name: 'text') }

          it 'should not raise and error when outputting to an hash' do
            expect { Elements::Base.build(element).to_hash }.to_not raise_error
          end
        end

        context 'persisted element' do
          it 'should not raise and error when outputting to an hash' do
            expect { Elements::Base.build(element).to_hash }.to_not raise_error
          end
        end
      end

      describe 'attributes' do
        context 'element with no content' do
          let(:hash) { Elements::Base.build(element).to_hash }

          attributes = %w(body stripped_body)
          it 'should have the following attributes: ' + attributes.join(',') do
            attributes.each do |attribute|
              expect(hash).to have_key(attribute.to_sym)
            end
          end
        end
      end

      describe 'alchemy to mustache mapping' do
        let(:essenc_richtext) { create (:alchemy_essence_richtext) }
        let(:alchemy_element) do
          create(:alchemy_element, name: 'text', contents: [create(:alchemy_content, essence: essenc_richtext, name: 'body')])
        end

        let(:mustache_data) { Europeana::Elements::Text.new(alchemy_element).to_hash }

        it 'has the right stripped body value' do
          expect(mustache_data[:stripped_body]).to eq(essenc_richtext.stripped_body)
        end
      end
    end
  end
end
