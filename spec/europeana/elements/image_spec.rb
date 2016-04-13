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
          it 'should have the following attributes: image, image_credit, is_landscape, is_portrait' do

            expect(hash).to have_key(:image)
            expect(hash).to have_key(:image_credit)
            expect(hash).to have_key(:is_landscape)
            expect(hash).to have_key(:is_portrait)
          end

          it 'should return false for image' do
            expect(hash[:image]).to equal(false)
          end

          it 'should have an attribute is_image that is true' do
            expect(hash[:is_image]).to equal(true)
          end
        end
      end

      describe 'alchemy to mustache mapping' do
        let(:essenc_picture) { create (:alchemy_essence_picture)}
        let(:alchemy_element) do
          create(:alchemy_element, name: 'image', contents: [create(:alchemy_content, essence: essenc_picture, name: 'image')])
        end

        let(:mustache_data) { Europeana::Elements::Image.new(alchemy_element).to_hash }

        it 'has all the required image versions' do
          expect(mustache_data[:image].keys).to eq([:original, :full, :fullx2, :half, :halfx2, :small, :smallx2, :thumbnail, :thumbnailx2, :thumbnail_png])
        end

        it 'has a correctly formatted path for "full" version' do
          expect(mustache_data[:image][:full][:url]).to match('show/1600x1600/85/image.jpeg')
        end

        context 'landscape image' do
          let(:essenc_picture) { create(:alchemy_essence_picture, picture: create(:landscape_picture))}

          it 'return true for is_landscape' do
            expect(mustache_data[:is_landscape]).to eq(true)
            expect(mustache_data[:is_portrait]).to eq(false)
          end
        end

        context 'portrait image' do
          let(:essenc_picture) { create(:alchemy_essence_picture, picture: create(:portrait_picture))}
          it 'return true for is_landscape' do
            expect(mustache_data[:is_landscape]).to eq(false)
            expect(mustache_data[:is_portrait]).to eq(true)
          end
        end
      end
    end
  end
end
