require 'rails_helper'

module Europeana
  describe 'Elements' do
    describe 'Text' do
      let(:element) { Alchemy::Element.create_from_scratch(name: 'text') }

      describe "#to_hash" do
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

          attributes =  %w(body stripped_body)
          it 'should have the following attributes: ' + attributes.join(',') do
            attributes.each do |attribute|
              expect(hash).to have_key(attribute.to_sym)
            end
          end
        end
      end
    end
  end
end
