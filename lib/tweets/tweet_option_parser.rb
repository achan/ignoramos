require 'optparse'

require 'tweets/media_status_persister'
require 'tweets/media_status_publisher'
require 'tweets/status_persister'
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
      options.persister = StatusPersister.new

      opts.on('-m',
              '--media [MEDIA_PATH]',
              'Attach media to tweet') do |media_path|
        options.media_path = media_path
        options.publisher = MediaStatusPublisher.new(media_path)
        options.persister = MediaStatusPersister.new(media_path)
      end
    end
  end

  def options
    @options ||= OpenStruct.new
  end
end
