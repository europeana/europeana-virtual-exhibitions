require 'rails_helper'

module Europeana
  describe 'Elements' do
    describe 'Image' do
      let(:element) { Alchemy::Element.create_from_scratch(name: 'image') }

      describe '#to_hash' do
        context 'new element' do
          let(:element) { Alchemy::Element.new_from_scratch(name: 'image') }

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
          it 'should have the following attributes: image, caption, image_credit, is_landscape, is_portrait' do

            expect(hash).to have_key(:image)
            expect(hash).to have_key(:caption)
            expect(hash).to have_key(:image_credit)
            expect(hash).to have_key(:is_landscape)
            expect(hash).to have_key(:is_portrait)
          end
          it 'should have an attribute is_image that is true' do
            expect(hash[:is_image]).to equal(true)
          end
        end
      end
    end
  end
end
