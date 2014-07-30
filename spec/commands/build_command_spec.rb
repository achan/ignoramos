require './lib/commands/build_command'

RSpec.describe BuildCommand do
  describe '#execute' do
    let(:command) { BuildCommand.new }

    before { command.execute }

    it 'drops rendered posts into the posts directory' do
      contents = File.open('spec/commands/testsite/_site/posts/2014-07-27-hello-world-pt-2.html', 'r') do |file|
        file.read()
      end

      actual = <<-ACTUAL
header

<p>Hey world!</p>

footer
ACTUAL

      expect(contents).to eq(actual)

      contents = File.open('spec/commands/testsite/_site/posts/2014-06-22-hello-world.html', 'r') do |file|
        file.read()
      end

      actual = <<-ACTUAL
header

<p>This is a test post. It&#39;s title is Test Post.</p>

footer
ACTUAL

      expect(contents).to eq(actual)
    end
  end
end

