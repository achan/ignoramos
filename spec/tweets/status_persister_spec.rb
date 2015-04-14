require 'spec_helper'
require 'tweets/status_persister'

describe StatusPersister do
  describe '#persist' do
    let(:tweet) { 'this is a tweet' }
    let(:tweet_id) { '12354' }
    let(:tweet_path) { "_posts/tweet-#{tweet_id}.md" }
    let(:tweet_url) { "https://twitter.com/amoschan/status/#{tweet_id}" }
    let(:now) { DateTime.now }
    let(:now_time) { Time.now }

    let(:remote_tweet) do
      double(uri: URI(tweet_url),
             id: tweet_id,
             created_at: now_time,
             text: tweet)
    end

    it 'persists the status tweet in its conventional location' do
      expect_any_instance_of(FileHelper).
        to receive(:new_file).with(tweet_path, expected_text_tweet)

      StatusPersister.new.persist(remote_tweet)
    end
  end

  def expected_text_tweet
    <<-END
---
title: tweet #{tweet_id}
timestamp: #{now.iso8601}
layout: tweet
tweet: #{tweet_url}
---

#{tweet}
END
  end
end
