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
    if tweet.entities && tweet.entities.media
      return tweet.entities.media.first.media_url
    end
  end
end
