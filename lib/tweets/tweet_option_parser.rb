require 'optparse'

require 'tweets/media_status_persister'
require 'tweets/media_status_publisher'
require 'tweets/no_op_publisher'
require 'tweets/remote_tweet_persister'
require 'tweets/status_publisher'

class TweetOptionParser
  def parse(*argv)
    parser.parse(*argv)
    options
  end

  private
  def parser
    OptionParser.new do |opts|
      options.publisher = StatusPublisher.new
      options.persister = MediaStatusPersister.new

      opts.on('-m',
              '--media [MEDIA_PATH]',
              'Attach media to tweet') do |media_path|
        options.media_path = media_path
        options.publisher = MediaStatusPublisher.new(media_path)
        options.persister = MediaStatusPersister.new(media: [media_path])
      end

      opts.on('-i',
              '--import [TWEET_ID]',
              'Import an existing tweet') do |tweet_id|
        options.tweet_id = tweet_id
        options.publisher = NoOpPublisher.new
        options.persister = RemoteTweetPersister.new(tweet_id)
      end
    end
  end

  def options
    @options ||= OpenStruct.new
  end
end
