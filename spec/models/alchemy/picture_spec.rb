# frozen_string_literal: true

RSpec.describe Alchemy::Picture do
  it { should have_many(:dragonfly_signatures).dependent(:destroy) }

  describe 'after_save' do
    it 'should process_versions' do
      expect(subject).to receive(:process_versions)
      subject.run_callbacks(:save) { true }
    end
  end
end
