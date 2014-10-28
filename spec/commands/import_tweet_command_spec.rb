require './lib/commands/import_tweet_command'
require 'shared_examples/tweet_command_examples'

RSpec.describe ImportTweetCommand do
  describe '#execute' do
    let(:command) { ImportTweetCommand.new(tweet_id) }
    let(:client_method) { :status }
    let(:client_args) { tweet_id }

    it_behaves_like "a command that writes a tweet to file"
  end
end
