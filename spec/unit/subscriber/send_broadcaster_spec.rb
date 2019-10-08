RSpec.describe WisperNext::Subscriber::SendBroadcaster do
  describe '#call' do
    let(:subscriber) { double }
    let(:event_name) { SecureRandom.uuid }
    let(:payload)    { SecureRandom.uuid }

    it 'sends event to subscriber' do
      expect(subscriber).to receive(event_name).with(payload)
      subject.call(subscriber, event_name, payload)
    end

    describe 'when public_send options is true' do
      it 'uses #send' do
        subject = described_class.new(public_send: true)
        expect(subscriber).to receive(:public_send).with(event_name, payload)
        subject.call(subscriber, event_name, payload)
      end
    end

    describe 'when public_send option is false' do
      it 'uses #send' do
        subject = described_class.new(public_send: false)
        expect(subscriber).to receive(:send).with(event_name, payload)
        subject.call(subscriber, event_name, payload)
      end
    end
  end
end
