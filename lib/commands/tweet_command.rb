require 'commands/base_tweet_command'

class TweetCommand < BaseTweetCommand
  def initialize(tweet)
    super()
    @tweet = tweet
  end

  def execute
    persist_tweet(twitter.update(@tweet))
  end
end
