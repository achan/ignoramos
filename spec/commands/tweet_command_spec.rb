require 'file_helper'
require 'commands/tweet_command'
require 'spec_helper'

RSpec.describe TweetCommand do
  describe "#execute" do
    context "when tweeting a text update" do
      it "publishes and persists a text update" do
        tweet = 'this is a tweet'
        remote_tweet = double('remote_tweet')
        persister = double(persist: true)
        publisher = double(publish: remote_tweet)
        expect(StatusPersister).to receive(:new).and_return(persister)
        expect(StatusPublisher).
          to receive(:new).with(tweet).and_return(publisher)
        expect(persister).to receive(:persist).with(remote_tweet)

        TweetCommand.new(tweet).execute
      end
    end

    context "when tweeting a media status update" do
      it "publishes and persists a media status update" do
        tweet = 'this is a tweet'
        image_path = '/tmp/image.png'
        remote_tweet = double('remote_tweet')
        persister = double(persist: true)
        publisher = double(publish: remote_tweet)
        expect(MediaStatusPersister).
          to receive(:new).with(image_path).and_return(persister)
        expect(MediaStatusPublisher).
          to receive(:new).with(tweet, image_path).and_return(publisher)
        expect(persister).to receive(:persist).with(remote_tweet)

        TweetCommand.new(tweet, image_path).execute
      end
    end
  end
end
