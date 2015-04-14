require 'twitter_client'

class StatusPublisher
  attr_reader :twitter_client, :tweet

  def initialize(tweet)
    @tweet = tweet
  end

  def publish
    twitter_client.update(tweet)
  end

  private
  def twitter_client
    @twitter_client ||= TwitterClient.new
  end
end
