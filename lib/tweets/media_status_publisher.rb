require 'twitter_client'

class MediaStatusPublisher
  attr_reader :tweet, :media_path

  def initialize(tweet, media_path)
    @tweet = tweet
    @media_path = media_path
  end

  def publish
    twitter_client.update_with_media(tweet, media_file)
  end

  private
  def media_file
    @media_file ||= File.new(media_path)
  end

  def twitter_client
    @twitter_client ||= TwitterClient.new
  end
end
