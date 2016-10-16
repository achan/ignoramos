require 'commands/build_command'
require 'commands/tweet_command'
require 'commands/new_command'
require 'pry'
require 'ignoramos'

RSpec.describe Ignoramos do
  shared_examples_for "a command executer" do
    let(:command) { double() }

    it 'instantiates a command and calls execute' do
      expect(command_class).
          to receive(:new).with(*args[1..-1]).and_return(command)
      expect(command).to receive(:execute)

      Ignoramos.new(args)
    end
  end

  shared_examples_for 'a command executer with no args' do
    let(:command) { double() }

    it 'instantiates a command and calls execute' do
      expect(command_class).to receive(:new).with(no_args).and_return(command)
      expect(command).to receive(:execute)

      Ignoramos.new(args)
    end
  end

  describe '#initialize' do
    describe 'when the command passed is "new"' do
      let(:args) { ['new', 'tempsite'] }
      let(:command_class) { NewCommand }

      it_behaves_like "a command executer"
    end

    describe 'when the command passed is "tweet"' do
      let(:args) { ['tweet', 'this is a tweet'] }
      let(:command_class) { TweetCommand }

      it_behaves_like "a command executer"
    end

    describe 'when the command passed is "build"' do
      let(:args) { ['build'] }
      let(:command_class) { BuildCommand }

      it_behaves_like "a command executer with no args"
    end

    describe 'when the command is unsupported' do
      let(:args) { ['asdasfsdfsd'] }
      let(:command_class) { Ignoramos::NilCommand }

      it_behaves_like "a command executer with no args"
    end
  end
end
