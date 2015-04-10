require 'commands/base_tweet_command'
require 'fileutils'

class TweetCommand < BaseTweetCommand
  IMAGE_TWEET_LAYOUT = <<-LAYOUT
---
title: tweet {{tweet.id}}
timestamp: {{tweet.timestamp}}
layout: tweet
tweet: {{tweet.url}}
image: {{tweet.image}}
---

{{tweet.content}}
LAYOUT

  def initialize(tweet, image_path=nil)
    super()
    @tweet = tweet
    @image_path = image_path
  end

  def execute
    persist_tweet(publish_to_twitter)
  end

  def additional_metadata(tweet)
    return {} unless image

    return { 'image' => copy_image(tweet.id) }
  end

  def tweet_layout
    super() unless image

    IMAGE_TWEET_LAYOUT
  end

  private
  def image
    @image ||= File.new(@image_path) if @image_path
  end

  def publish_to_twitter
    if image
      twitter.update_with_media(@tweet, image)
    else
      twitter.update(@tweet)
    end
  end

  def copy_image(tweet_id)
    FileUtils.mkdir_p("#{Dir.pwd}/img/tweets")
    FileUtils.cp(@image_path, conventional_filename(tweet_id))

    conventional_filename(tweet_id)
  end

  def conventional_filename(tweet_id)
    "#{Dir.pwd}/img/tweets/#{tweet_id}-#{File.basename(image)}"
  end
end
