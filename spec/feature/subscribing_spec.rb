require 'securerandom'

RSpec.describe 'publishing locally' do
  it 'publishes events to subscribed listeners' do
    publisher = Class.new do
      include WisperNext.publisher

      def call(name, payload)
        broadcast(name, payload)
      end
    end.new

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
end
