require 'rails_helper'

module Europeana
  describe 'Elements' do
    describe 'Image' do
      let(:element) { Alchemy::Element.new_from_scratch(name: 'image') }

      describe '#to_hash' do
        it 'should not raise and error when outputting to an hash' do
          Elements::Base.build(element).to_hash
        end
      end
    end
  end
end
