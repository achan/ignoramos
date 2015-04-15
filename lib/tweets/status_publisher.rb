require 'twitter_client'

class StatusPublisher
  attr_reader :twitter_client

  def publish(tweet)
    twitter_client.update(tweet)
  end

  private
  def twitter_client
    @twitter_client ||= TwitterClient.new
  end
end
