require './lib/commands/build_command'

RSpec.describe BuildCommand do
  describe '#execute' do
    let(:command) { BuildCommand.new }

    before { command.execute }

    it 'drops rendered posts into the posts directory' do
      contents = File.open('spec/commands/testsite/_site/posts/2014-07-27-hello-world-pt-2.html', 'r') do |file|
        file.read()
      end

      expect(contents).to eq('Hey world!')

      contents = File.open('spec/commands/testsite/_site/posts/2014-06-22-hello-world.html', 'r') do |file|
        file.read()
      end

      expect(contents).to eq('This is a test post. It\'s title is Test Post.')
    end
  end
end

