require './lib/commands/build_command'
require 'fakefs/spec_helpers'

RSpec.describe BuildCommand do
  describe '#execute' do
    include FakeFS::SpecHelpers

    let(:command) { BuildCommand.new }

    before { command.execute }

  end
end

