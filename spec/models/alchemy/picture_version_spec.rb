# frozen_string_literal: true

RSpec.describe Alchemy::PictureVersion do
  it { should have_one(:dragonfly_signature) }
  describe 'with signature scope' do
    described_class { should respond_to(:with_signature) }
  end
end
