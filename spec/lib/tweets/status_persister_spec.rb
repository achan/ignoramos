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

    let(:image_to_tweet) { double(to_s: '/tmp/image.png') }
    let(:tweet_image_paths) { ["/tmp/image.jpg", "/tmp/image2.jpg"] }
    let(:relative_tweet_paths) do
      ["/img/tweets/#{tweet_id}-image.jpg", "/img/tweets/#{tweet_id}-image.jpg"]
    end
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
        to receive(:new_file).with(tweet_path, serialized_tweet_with_images)

      StatusPersister.new(media: tweet_image_paths).persist(remote_tweet)
    end

    context 'when there are no images to tweet' do
      it 'persists the status tweet in its conventional location' do
        allow(FileUtils).to receive(:mkdir_p)
        expect_any_instance_of(FileHelper).
          to receive(:new_file).with(tweet_path, serialized_tweet_without_images)
        StatusPersister.new(media: []).persist(remote_tweet)
      end
    end
  end

    def serialized_tweet_with_images
      <<-END
---
title: tweet #{tweet_id}
timestamp: #{now.iso8601}
layout: tweet
tweet: #{tweet_url}
images:
- #{relative_tweet_paths[0]}
- #{relative_tweet_paths[1]}
---

#{tweet}
END
    end

    def serialized_tweet_without_images
      <<-END
---
title: tweet #{tweet_id}
timestamp: #{now.iso8601}
layout: tweet
tweet: #{tweet_url}
images:
---

#{tweet}
END
    end
end
