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
images:{% for image in tweet.images %}\n- {{image}}{% endfor %}
---

{{tweet.content}}
LAYOUT

  def initialize(media: [])
    @image_paths = media
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
                             'images' => copy_images_to_blog(tweet.id)
                           }
                         }))
  end

  def layout
    LAYOUT
  end

  private
  def copy_images_to_blog(tweet_id)
    FileUtils.mkdir_p("#{Dir.pwd}/img/tweets")
    @image_paths.
      each { |p| copy_image(tweet_id, p) }.
      map { |p| conventional_filename(tweet_id, p) }
  end

  def copy_image(tweet_id, image_path)
    FileUtils.
      cp(image_path, "#{Dir.pwd}#{conventional_filename(tweet_id, image_path)}")
  end

  def conventional_filename(tweet_id, image_path)
    "/img/tweets/#{tweet_id}-#{File.basename(File.new(image_path))}"
  end
end
