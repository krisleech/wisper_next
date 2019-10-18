RSpec.describe 'publishing' do
  let(:publisher) do
    Class.new do
      include WisperNext.publisher

      def call(name, payload)
        broadcast(name, payload)
      end
    end.new
  end

  it 'publishes events to subscribed listeners' do
    listener = Class.new do
      attr_reader :events

      def initialize
        @events = []
      end

      def on_event(name, payload)
        @events << { name: name, payload: payload }
      end
    end.new

    publisher.subscribe(listener)

    name    = SecureRandom.uuid
    payload = SecureRandom.uuid

    publisher.call(name, payload)

    expect(listener.events).to eq([name: name, payload: payload])
  end

  describe 'when block subscribed' do
    let(:payload)    { SecureRandom.uuid }
    let(:event_name) { SecureRandom.uuid }
    let(:block)      { lambda { |payload| raise(payload) } }

    describe 'and event name matches' do
      it 'calls block with payload' do
        publisher.on(event_name, &block)
        expect { publisher.call(event_name, payload) }.to raise_error(payload)
      end
    end

    describe 'and event name does not match' do
      it 'does not call block' do
        publisher.on(SecureRandom.uuid, &block)
        expect { publisher.call(SecureRandom.uuid, payload) }.not_to raise_error
      end
    end

    describe 'when block is subscribed twice to the same event' do
      it 'raises an error' do
        publisher.on(:one, &block)
        expect { publisher.on(:one, &block) }.to raise_error(WisperNext::Publisher::ListenerAlreadyRegisteredError)
      end
    end

    it 'allows further blocks to be chained' do
      expect do
        publisher.on(:one) {}
                 .on(:two) {}
      end.not_to raise_error
    end
  end
end
