require 'spec_helper'
require 'tweets/media_status_publisher'
require 'twitter_client'

describe MediaStatusPublisher do
  describe "#publish" do
    it 'posts an update to twitter' do
      tweet = 'this is a tweet'
      media = '/tmp/test.png'

      media_file = double('file')
      allow(File).to receive(:new).with(media).and_return(media_file)
      expect_any_instance_of(TwitterClient).
        to receive(:update_with_media).with(tweet, media_file)

      MediaStatusPublisher.new(media).publish(tweet)
    end
  end
end

