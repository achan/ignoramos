require 'twitter_client'

RSpec.describe TwitterClient do
  let(:settings) do
    Settingslogic.new('site' => { 'name' => 'My First Blog',
                                  'tagline' => 'Test tagline',
                                  'description' => 'Site description',
                                  'user' => 'Test user',
                                  'site_map' => '',
                                  'post_limit' => 3 })
  end

  let(:tweet) { 'this is a tweet' }
  let(:tweet_id) { '12354' }
  let(:tweet_url) { "https://twitter.com/amoschan/status/#{tweet_id}" }
  let(:now_time) { Time.now }

  let(:client) { TwitterClient.new }

  before do
    allow_any_instance_of(TwitterAccessTokenService).
        to receive(:call).and_return(double(token: 'token', secret: 'secret'))

    allow(Settings).to receive(:new).and_return(settings)
  end

  describe "#update" do
    let(:remote_tweet) do
      double(uri: URI(tweet_url),
             id: tweet_id,
             created_at: now_time,
             text: tweet)
    end

    it "delegates to twitter#update" do
      expect_any_instance_of(Twitter::REST::Client).
          to receive(:update).with(tweet).and_return(remote_tweet)
      expect(client.update(tweet)).to eq(remote_tweet)
    end
  end

  describe '#update_with_media' do
    let(:image_to_tweet) { double(to_s: '/tmp/image.png') }
    let(:remote_tweet) do
      double(uri: URI(tweet_url),
             id: tweet_id,
             created_at: now_time,
             text: tweet)
    end

    before do
      expect_any_instance_of(Twitter::REST::Client).
          to receive(:update_with_media).with(tweet, image_to_tweet).
                                         and_return(remote_tweet)
    end

    it "persists an image tweet into its conventional location" do
      expect(client.update_with_media(tweet, image_to_tweet)).
        to eq(remote_tweet)
    end
  end
end
