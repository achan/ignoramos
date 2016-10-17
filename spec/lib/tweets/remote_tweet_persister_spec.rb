require 'spec_helper'
require 'tweets/remote_tweet_persister'
require 'tweets/remote_tweet_persister'
require 'tweets/status_persister'
require 'twitter_client'
require "pry"

describe RemoteTweetPersister do
  describe "#persist" do
    let(:tweet_id) { '1212134' }

    context "when remote tweet is a text update" do
      let(:remote_tweet) { double('remote_tweet', media: []) }
      let(:persister) { double(:persister) }

      it "delegates to StatusPersister" do
        expect(StatusPersister).
          to receive(:new).with([]).and_return(persister)
        expect_any_instance_of(TwitterClient).
          to receive(:status).with(tweet_id).and_return(remote_tweet)
        expect(persister).to receive(:persist).with(remote_tweet)
        RemoteTweetPersister.new(tweet_id).persist
      end
    end

    context "when remote tweet has media" do
      let(:image_path) { 'spec/fixtures/remote_image.jpg' }
      let(:remote_tweet) do
        double('remote_tweet',
               id: tweet_id,
               media: [double(media_uri: Addressable::URI.parse(image_path))])
      end
      let(:image_content) { "random image content" }

      let(:persister) { double(:persister) }

      it 'delegates to StatusPersister' do
        expect_any_instance_of(TwitterClient).to receive(:status).
          with(tweet_id).and_return(remote_tweet)
        expect(StatusPersister).to receive(:new).
          with(["/tmp/#{tweet_id}.jpg"]).and_return(persister)
        expect(persister).to receive(:persist).with(remote_tweet)
        RemoteTweetPersister.new(tweet_id).persist
        expect(FileUtils.compare_file("/tmp/#{tweet_id}.jpg", "spec/fixtures/remote_image.jpg")).
          to eq true
      end
    end
  end
end
