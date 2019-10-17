RSpec.describe WisperNext::CastToOptions do
  subject { described_class }

  describe '#call' do
    describe 'given no arguments' do
      it 'returns an empty Hash' do
        expect(subject.call([])).to eq({})
      end
    end

    describe 'given a symbol' do
      it 'returns a Hash with the symbol as a key and the value as true' do
        expect(subject.call([:strict])).to eq(strict: true)
      end
    end

    describe 'given a Hash' do
      it 'returns the same Hash' do
        expect(subject.call([{ async: true }])).to eq(async: true)
      end
    end

    describe 'given a symbols followed by a Hash' do
      it 'returns a Hash with the symbol expanded and the hash' do
        expect(subject.call([:strict, :prefix, { async: false }])).to eq(strict: true, prefix: true, async: false)
      end
    end
  end
end
