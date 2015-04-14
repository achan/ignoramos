class TweetOptionParser
  def parse(*argv)
    parser.parse(*argv)
    options
  end

  private
  def parser
    OptionParser.new do |opts|
      opts.on('-m',
              '--media [MEDIA_PATH]',
              'Attach media to tweet') do |media_path|
        options.media_path = media_path
      end
    end
  end

  def options
    @options ||= OpenStruct.new
  end
end
