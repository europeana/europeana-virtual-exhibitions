# frozen_string_literal: true

RSpec.describe Alchemy::Picture do
  it { should have_many(:dragonfly_signatures).dependent(:destroy) }
end
