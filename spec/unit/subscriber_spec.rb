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

      describe 'and strict option is false' do
        subject(:subscriber) do
          Class.new { include WisperNext.subscriber(strict: false) }.new
        end

        it 'does not raise an error' do
          expect { subject.on_event(event_name, payload) }.not_to raise_error
        end
      end
    end

    describe 'when async option is set to true' do
      let(:async_broadcaster) { double }

      before { stub_const('WisperNext::Subscriber::AsyncBroadcaster', async_broadcaster) }

      subject(:subscriber) { Class.new { include WisperNext.subscriber(async: true) }.new }

      it 'uses async broadcaster' do
        allow(subscriber).to receive(event_name)
        expect(async_broadcaster).to receive(:call).with(subscriber, event_name, payload)
        subject.on_event(event_name, payload)
      end
    end

    describe 'when broadcaster option is set' do
      describe 'and broadcaster is a symbol' do
        let(:sidekiq_broadcaster) { double }

        before { stub_const('WisperNext::Subscriber::SidekiqBroadcaster', sidekiq_broadcaster) }

        subject(:subscriber) { Class.new { include WisperNext.subscriber(broadcaster: :sidekiq) }.new }

        it 'maps symbol to a broadcaster class' do
          allow(subscriber).to receive(event_name)
          expect(sidekiq_broadcaster).to receive(:call).with(subscriber, event_name, payload)
          subject.on_event(event_name, payload)
        end
      end
    end
  end
end
