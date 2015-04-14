require 'file_helper'
require 'liquid'

class MediaStatusPersister
  attr_reader :file_helper, :image

  LAYOUT = <<-LAYOUT
---
title: tweet {{tweet.id}}
timestamp: {{tweet.timestamp}}
layout: tweet
tweet: {{tweet.url}}
image: {{tweet.image}}
---

{{tweet.content}}
LAYOUT

  def initialize(image_path)
    @image_path = image_path
    @file_helper = FileHelper.new(Dir.pwd)
  end

  def persist(tweet)
    file_helper.new_file("_posts/tweet-#{tweet.id}.md",
                         Liquid::Template.parse(layout).render({
                           'tweet' => {
                             'content' => tweet.text,
                             'id' => tweet.id,
                             'url' => tweet.uri.to_s,
                             'timestamp' => DateTime.parse(tweet.created_at.to_s),
                             'image' => copy_image(tweet.id)
                           }
                         }))
  end

  def layout
    LAYOUT
  end

  private
  def image
    @image ||= File.new(@image_path)
  end

  def copy_image(tweet_id)
    FileUtils.mkdir_p("#{Dir.pwd}/img/tweets")
    FileUtils.cp(@image_path, "#{Dir.pwd}#{conventional_filename(tweet_id)}")

    conventional_filename(tweet_id)
  end

  def conventional_filename(tweet_id)
    "/img/tweets/#{tweet_id}-#{File.basename(image)}"
  end
end
