RSpec.describe WisperNext::Subscriber::ResolveMethod do
  subject { described_class }

  describe '#call' do
    describe 'when prefix is true' do
      it 'returns name with "on_" prepended' do
        expect(subject.call("success", true)).to eq("on_success")
      end
    end

    describe 'when prefix is false' do
      it 'returns name' do
        expect(subject.call("success", false)).to eq("success")
      end
    end
  end
end
