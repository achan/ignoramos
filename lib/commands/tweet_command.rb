require 'fileutils'

require 'tweets/tweet_option_parser'

class TweetCommand
  attr_reader :publisher, :persister, :tweet

  def initialize(*args)
    @tweet = args.first
    options = TweetOptionParser.new.parse(args)

    @publisher = options.publisher
    @persister = options.persister
  end

  def execute
    persister.persist(publisher.publish(tweet))
  end
end
