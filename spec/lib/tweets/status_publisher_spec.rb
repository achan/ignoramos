require 'spec_helper'
require 'tweets/status_publisher'
require 'twitter_client'

describe StatusPublisher do
  describe "#publish" do
    it 'posts an update to twitter' do
      tweet = 'this is a tweet'
      expect_any_instance_of(TwitterClient).to receive(:update).with(tweet)

      StatusPublisher.new(tweet).publish
    end
  end
end
