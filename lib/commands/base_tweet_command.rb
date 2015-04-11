require 'file_helper'
require 'liquid'
require 'models/post'
require 'models/settings'
require 'twitter_client'

class BaseTweetCommand
  attr_reader :file_helper

  TWEET_LAYOUT = <<-LAYOUT
---
title: tweet {{tweet.id}}
timestamp: {{tweet.timestamp}}
layout: tweet
tweet: {{tweet.url}}
---

{{tweet.content}}
LAYOUT

  def initialize
    @file_helper = FileHelper.new(Dir.pwd)
  end

  protected
  def twitter
    @twitter ||= TwitterClient.new
  end

  def persist_tweet(tweet)
    file_helper.new_file("_posts/tweet-#{tweet.id}.md",
                          Liquid::Template.parse(tweet_layout).render({
                            'tweet' => {
                              'content' => tweet.text,
                              'id' => tweet.id,
                              'url' => tweet.uri.to_s,
                              'timestamp' => DateTime.parse(tweet.created_at.to_s)
                            }.merge(additional_metadata(tweet))
                          }))
  end

  def tweet_layout
    TWEET_LAYOUT
  end

  def additional_metadata(tweet)
    {}
  end
end
