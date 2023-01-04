describe Fastlane::Actions::FtpsAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The ftps plugin is working!")

      Fastlane::Actions::FtpsAction.run(nil)
    end
  end
end
