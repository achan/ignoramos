require 'file_helper'
require 'liquid'

class StatusPersister
  attr_reader :file_helper

  LAYOUT = <<-LAYOUT
---
title: tweet {{tweet.id}}
timestamp: {{tweet.timestamp}}
layout: tweet
tweet: {{tweet.url}}
---

{{tweet.content}}
LAYOUT

  def persist(tweet)
    file_helper.new_file("_posts/tweet-#{tweet.id}.md",
                         Liquid::Template.parse(layout).render({
                           'tweet' => {
                             'content' => tweet.text,
                             'id' => tweet.id,
                             'url' => tweet.uri.to_s,
                             'timestamp' => DateTime.parse(tweet.created_at.to_s)
                           }
                         }))
  end

  def layout
    LAYOUT
  end

  private
  def file_helper
    @file_helper ||= FileHelper.new(Dir.pwd)
  end
end
