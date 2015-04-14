require 'spec_helper'
require 'tweets/media_status_persister'

describe MediaStatusPersister do
  describe '#persist' do
    let(:tweet) { 'this is a tweet' }
    let(:tweet_id) { '12354' }
    let(:tweet_path) { "_posts/tweet-#{tweet_id}.md" }
    let(:tweet_url) { "https://twitter.com/amoschan/status/#{tweet_id}" }
    let(:now) { DateTime.now }
    let(:now_time) { Time.now }

    let(:image_to_tweet) { double(to_s: '/tmp/image.png') }
    let(:tweet_image_path) { "/tmp/image.jpg" }
    let(:relative_tweet_path) { "/img/tweets/#{tweet_id}-image.jpg" }
    let(:remote_tweet) do
      double(uri: URI(tweet_url),
             id: tweet_id,
             created_at: now_time,
             text: tweet)
    end

    it 'persists the status tweet in its conventional location' do
      allow(FileUtils).to receive(:mkdir_p)
      allow(FileUtils).to receive(:cp)
      allow(File).to receive(:new).and_return(image_to_tweet)
      allow(File).
        to receive(:basename).with(image_to_tweet).and_return('image.jpg')

      expect_any_instance_of(FileHelper).
        to receive(:new_file).with(tweet_path, expected_text_tweet)

      MediaStatusPersister.new(tweet_image_path).persist(remote_tweet)
    end
  end

    def expected_text_tweet
      <<-END
---
title: tweet #{tweet_id}
timestamp: #{now.iso8601}
layout: tweet
tweet: #{tweet_url}
image: #{relative_tweet_path}
---

#{tweet}
END
    end
end

