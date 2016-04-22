require 'rails_helper'

module Europeana
  describe 'Elements' do
    describe 'Intro' do
      let(:element) { Alchemy::Element.create_from_scratch(name: 'intro') }

      describe '#to_hash' do
        context 'new element' do
          let(:element) { Alchemy::Element.new_from_scratch(name: 'intro') }

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

          attributes = %w(intro_description stripped_intro_description image title sub_title image_credit label partner_image)
          it 'should have the following attributes: ' + attributes.join(',') do
            attributes.each do |attribute|
              expect(hash).to have_key(attribute.to_sym)
            end
          end
          it 'should have an attribute is_image that is true' do
            expect(hash[:is_intro]).to equal(true)
          end
        end
      end
    end
  end
end
