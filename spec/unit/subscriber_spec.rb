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

    describe 'when prefix option is set to true' do
      subject(:subscriber) { Class.new { include WisperNext.subscriber(prefix: true) }.new }
      it 'prefixes the method with "on_"' do
        expect(subject).to receive("on_" + event_name).with(payload)
        subject.on_event(event_name, payload)
      end
    end

    describe 'when async option is set to true' do
      let(:async_broadcaster_class) { double(new: async_broadcaster) }
      let(:async_broadcaster) { double }

      before { stub_const('WisperNext::Subscriber::AsyncBroadcaster', async_broadcaster_class) }

      subject(:subscriber) { Class.new { include WisperNext.subscriber(async: true) }.new }

      it 'uses async broadcaster' do
        allow(subscriber).to receive(event_name)
        allow(async_broadcaster_class).to receive(:new).and_return(async_broadcaster)
        expect(async_broadcaster).to receive(:call).with(subscriber, event_name, payload)
        subject.on_event(event_name, payload)
      end
    end

    describe 'when broadcaster option is set' do
      describe 'and broadcaster is an object' do
        before { stub_const("MyBroadcaster", broadcaster) }

        let(:broadcaster) { double }

        subject(:subscriber) { Class.new { include WisperNext.subscriber(broadcaster: MyBroadcaster) }.new }

        it 'calls object' do
          allow(subscriber).to receive(event_name)
          expect(broadcaster).to receive(:call).with(subscriber, event_name, payload)
          subject.on_event(event_name, payload)
        end
      end

      describe 'and broadcaster is a symbol' do
        let(:sidekiq_broadcaster_class) { double(new: sidekiq_broadcaster) }
        let(:sidekiq_broadcaster)       { double }

        before { stub_const('WisperNext::Subscriber::SidekiqBroadcaster', sidekiq_broadcaster_class) }

        subject(:subscriber) { Class.new { include WisperNext.subscriber(broadcaster: :sidekiq) }.new }

        it 'maps symbol to a broadcaster class' do
          allow(subscriber).to receive(event_name)
          allow(sidekiq_broadcaster_class).to receive(:new).and_return(sidekiq_broadcaster)
          expect(sidekiq_broadcaster).to receive(:call).with(subscriber, event_name, payload)
          subject.on_event(event_name, payload)
        end
      end
    end
  end
end
