# frozen_string_literal: true

RSpec.describe Alchemy::PictureVersion do
  it { should have_one(:dragonfly_signature) }
end
