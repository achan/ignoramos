require 'twitter_client'
require 'tweets/status_persister'

class RemoteTweetPersister
  attr_reader :tweet_id

  def initialize(tweet_id)
    @tweet_id = tweet_id
  end

  def persist(_=nil)
    tweet = twitter_client.status(tweet_id)
    media = media_from_tweet(tweet)
    if media
      MediaStatusPersister.new(media)
    else
      StatusPersister.new
    end.persist(tweet)
  end

  private
  def twitter_client
    @twitter_client ||= TwitterClient.new
  end

  def media_from_tweet(tweet)
    return save_to_tmp(tweet) if tweet.media?
  end

  def save_to_tmp(tweet)
    open(temporary_path(tweet), 'wb') do |file|
      file << open(tweet.media.first.media_uri).read
    end
  end

  def temporary_path(tweet)
    media_url = tweet.media.first.media_uri
    "/tmp/#{tweet.id}.#{extension(media_url)}"
  end

  def extension(url)
    url[url.rindex('.') + 1..url.length]
  end
end
