require "twitter_client"
require "tweets/status_persister"

class RemoteTweetPersister
  attr_reader :tweet_id

  def initialize(tweet_id)
    @tweet_id = tweet_id
  end

  def persist(_=nil)
    tweet = twitter_client.status(tweet_id)
    StatusPersister.new(media: media_from_tweet(tweet)).persist(tweet)
  end

  private

  def twitter_client
    @twitter_client ||= TwitterClient.new
  end

  def media_from_tweet(tweet)
    media_paths(tweet).
      map { |path| save_to_tmp(path) }.
      map(&:path)
  end

  def save_to_tmp(media_path)
    open(temporary_path(media_path), 'wb') do |file|
      open(media_path, "r") { |remote_file| file << remote_file.read }
    end
  end

  def temporary_path(media_path)
    "/tmp/#{@tweet_id}.#{extension(media_path)}"
  end

  def media_paths(tweet)
    tweet.media.map { |media| media.media_uri.to_s }
  end

  def extension(url)
    url[url.rindex('.') + 1..url.length]
  end
end
