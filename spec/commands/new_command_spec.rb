require './lib/commands/new_command'

RSpec.describe NewCommand do
  it 'accepts a directory string in initializer' do
    expect(NewCommand.new('testdir').dir).to eq('testdir')
  end
end
