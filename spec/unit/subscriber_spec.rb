require 'securerandom'

RSpec.describe WisperNext::Subscriber do
  subject(:subscriber) do
    Class.new { include WisperNext.subscriber }.new
  end

  describe '#on_event' do
    let(:event_name) { 'hello' }
    let(:payload)    { SecureRandom.uuid }

    describe 'when subscriber has method matching event name' do
      it 'calls method' do
        expect(subject).to receive(event_name).with(payload)
        subject.on_event(event_name, payload)
      end
    end

    describe 'when subscriber has no method matching event name' do
      it 'raises an error' do
        expect { subject.on_event(event_name, payload) }.to raise_error(WisperNext::Subscriber::NoMethodError)
      end
    end
  end
end
