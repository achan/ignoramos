require 'twitter_client'

class RemoteTweetPersister
  attr_reader :tweet_id

  def initialize(tweet_id)
    @tweet_id = tweet_id
  end

  def persist(_=nil)
    tweet = twitter_client.status(tweet_id)
    media = media_from_tweet(tweet)
    persister = StatusPersister.new(media: media)

    persister.persist(tweet)
  end

  private

  def twitter_client
    @twitter_client ||= TwitterClient.new
  end

  def media_from_tweet(tweet)
    media_paths(tweet).map { |p| save_to_tmp(tweet, p) }
  end

  def save_to_tmp(tweet, media_path)
    open(temporary_path(tweet, media_path), 'wb') do |file|
      file << open(media_path).read
    end.path
  end

  def temporary_path(tweet, media_path)
    "/tmp/#{tweet.id}.#{extension(media_path)}"
  end

  def media_paths(tweet)
    tweet.media.map { |media| media.media_uri.to_s }
  end

  def extension(url)
    url[url.rindex('.') + 1..url.length]
  end
end
