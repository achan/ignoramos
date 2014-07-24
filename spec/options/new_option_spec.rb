require './lib/options/new_option'

RSpec.describe NewOption do
  it 'accepts a directory string in initializer' do
    expect(NewOption.new('testdir').dir).to eq('testdir')
  end
end
