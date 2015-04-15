require 'twitter_client'

class MediaStatusPublisher
  attr_reader :media_path

  def initialize(media_path)
    @media_path = media_path
  end

  def publish(tweet)
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
