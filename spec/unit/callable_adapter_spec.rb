RSpec.describe WisperNext::CallableAdapter do
  subject { described_class.new(event_name, callable) }

  let(:callable) { double }

  let(:event_name) { SecureRandom.uuid }
  let(:payload)    { SecureRandom.uuid }

  it 'is frozen' do
    expect(subject.frozen?).to be(true)
  end

  describe '#on_event' do
    describe 'when event matches' do
      it 'calls block' do
        expect(callable).to receive(:call).with(payload)
        subject.on_event(event_name, payload)
      end
    end

    describe 'when event does not match' do
      it 'does not call block' do
        expect(callable).not_to receive(:call)
        subject.on_event(:something_else, payload)
      end
    end
  end

  describe '#==' do
    describe 'when given object is the callable' do
      it 'returns true' do
        other = described_class.new(event_name, callable)
        expect(subject == other).to eq(true)
      end
    end

    describe 'when given object is not the callable' do
      it 'returns false' do
        other = described_class.new(event_name, lambda {})
        expect(subject == other).to eq(false)
      end
    end
  end
end
