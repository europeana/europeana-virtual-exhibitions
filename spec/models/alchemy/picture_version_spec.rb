# frozen_string_literal: true

RSpec.describe Alchemy::PictureVersion do
  it { should have_one(:alchemy_dragonfly_signature).dependent(:destroy) }
end
