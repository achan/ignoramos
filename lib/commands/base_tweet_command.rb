require 'liquid'
require 'models/post'
require 'models/settings'
require 'twitter'
require 'twitter/tweet'
require 'file_helper'

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
    @twitter ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = "RerlMuPVgYySMdqvuaBeSw"
      config.consumer_secret     = "Ccq3hS7fMplpjwCfvpVyPQXV6nPGGGonXSAdmi8ZIc"
      config.access_token        = Settings.twitter.access_token
      config.access_token_secret = Settings.twitter.access_token_secret
    end
  end

  def persist_tweet(tweet)
    file_helper.new_file("_posts/tweet-#{tweet.id}.md",
                          Liquid::Template.parse(TWEET_LAYOUT).render({
                            'tweet' => {
                              'content' => tweet.text,
                              'id' => tweet.id,
                              'url' => tweet.uri.to_s,
                              'timestamp' => DateTime.parse(tweet.created_at.to_s)
                            }
                          }))
  end
end
