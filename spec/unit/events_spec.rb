RSpec.describe WisperNext::Events do
  describe '#subscribe' do
    it 'subscribes listener' do
      listener = double(on_event: nil)
      subject.subscribe(listener)
      expect(subject.subscribed?(listener)).to eq(true)
    end
  end

  describe '#broadcast' do
    it 'broadcasts event to all susbcribers' do
      listener   = double

      event_name = SecureRandom.uuid
      payload    = SecureRandom.uuid

      expect(listener).to receive(:on_event).with(event_name, payload)

      subject.subscribe(listener)
      subject.broadcast(event_name, payload)
    end
  end
end
