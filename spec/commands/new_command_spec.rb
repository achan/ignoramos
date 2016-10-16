require './lib/commands/new_command'

RSpec.describe NewCommand do
  describe '#execute' do
    let(:command) { NewCommand.new('testdir') }

    before { command.execute }

    it 'creates folder for drafts' do
      expect(File.directory?('testdir/_drafts')).to be_truthy
    end

    it 'creates folder for posts' do
      expect(File.directory?('testdir/_posts')).to be_truthy
    end

    it 'creates folder for pages' do
      expect(File.directory?('testdir/_pages')).to be_truthy
    end

    it 'creates folder for includes' do
      expect(File.directory?('testdir/_includes')).to be_truthy
    end

    it 'creates folder for layout templates' do
      expect(File.directory?('testdir/_layouts')).to be_truthy
    end

    it 'creates folder for generated site' do
      expect(File.directory?('testdir/_site')).to be_truthy
    end
  end
end
