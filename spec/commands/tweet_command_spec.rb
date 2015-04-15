require 'file_helper'
require 'commands/tweet_command'
require 'spec_helper'

RSpec.describe TweetCommand do
  describe "#execute" do
    let(:publisher) { double('publisher') }
    let(:persister) { double('persister') }
    let(:options) { double(publisher: publisher, persister: persister) }
    let(:remote_tweet) { double('remote_tweet') }
    let(:tweet) { 'this is a tweet' }
    
    it 'persists the published tweet' do
      expect_any_instance_of(TweetOptionParser).
        to receive(:parse).with(['other', 'options']).
                           and_return(options)
      expect(publisher).
        to receive(:publish).with(tweet).and_return(remote_tweet)
      expect(persister).to receive(:persist).with(remote_tweet)

      TweetCommand.new(tweet, 'other', 'options').execute
    end
  end
end
