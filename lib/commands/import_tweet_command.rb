require 'commands/base_tweet_command'
class ImportTweetCommand < BaseTweetCommand
  def initialize(tweet_id)
    super()
    @tweet_id = tweet_id
  end

  def execute
    persist_tweet(twitter.status(@tweet_id))
  end
end

# {
#   entities: {
#     media: [
#       {
#         media_url: 'http://example.com/image.jpg'
#       }
#     ]
#   }
# }
