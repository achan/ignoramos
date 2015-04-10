require 'commands/base_tweet_command'

class TweetCommand < BaseTweetCommand
  def initialize(tweet, image_path=nil)
    super()
    @tweet = tweet
    @image_path = image_path
  end

  def execute
    print "tweeting #{@tweet} and #{image}"

    if image
      twitter.update_with_media(@tweet, image)
    else
      persist_tweet(twitter.update(@tweet))
    end
  end

  private
  def image
    @image ||= File.new(@image_path) if @image_path
  end
end
