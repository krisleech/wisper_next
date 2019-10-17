require 'securerandom'

RSpec.describe WisperNext::Publisher do
  subject(:publisher) do
    Class.new do
      include WisperNext.publisher

      public :broadcast
    end.new
  end

  let(:listener) { double('listener') }

  describe '#subscribe' do
    it 'subscribes the given listener' do
      publisher.subscribe(listener)
      expect(publisher.subscribed?(listener)).to eq(true)
    end

    it 'retutns self' do
      expect(publisher.subscribe(listener)).to eq(publisher)
    end

    describe 'when the given listener is already subscribed' do
      it 'raises an error' do
        publisher.subscribe(listener)
        expect { publisher.subscribe(listener) }.to raise_error(described_class::ListenerAlreadyRegisteredError)
      end
    end
  end

  describe '#on' do
    it 'subscribes given listener' do
      block = lambda {}
      publisher.on(:something, &block)
      expect(publisher.subscribed?(block)).to eq(true)
    end

    it 'returns self' do
      expect(publisher.on(:something) {}).to eq(publisher)
    end

    describe 'when no block given' do
      it 'raises an error' do
        expect { publisher.on(:something) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#broadcast' do
    it 'calls on_event on subscribed listeners' do
      publisher.subscribe(listener)

      event_name = SecureRandom.uuid
      payload    = SecureRandom.uuid

      expect(listener).to receive(:on_event).with(event_name, payload)

      publisher.broadcast(event_name, payload)
    end

    it 'returns self' do
      expect(publisher.broadcast(:anything, :anything)).to eq(publisher)
    end
  end
end
