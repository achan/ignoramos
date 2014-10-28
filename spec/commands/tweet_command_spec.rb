require 'commands/tweet_command'
require 'shared_examples/tweet_command_examples'

RSpec.describe TweetCommand do
  describe '#execute' do
    let(:command) { TweetCommand.new(tweet) }
    let(:client_method) { :update }
    let(:client_args) { tweet }

    it_behaves_like "a command that writes a tweet to file"
  end
end
