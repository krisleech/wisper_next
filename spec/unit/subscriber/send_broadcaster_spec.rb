RSpec.describe WisperNext::Subscriber::SendBroadcaster do
  subject { described_class }

  describe '#call' do
    it 'sends event to subscriber' do
      subscriber = double
      event_name = SecureRandom.uuid
      payload = SecureRandom.uuid
      expect(subscriber).to receive(event_name).with(payload)
      subject.call(subscriber, event_name, payload)
    end
  end
end

