require 'file_helper'
require 'liquid'
require 'models/post'
require 'models/settings'
require 'services/twitter_access_token_service'
require 'twitter'
require 'twitter/tweet'

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
      config.access_token        = access_token.token
      config.access_token_secret = access_token.secret
    end
  end

  def persist_tweet(tweet)
    file_helper.new_file("_posts/tweet-#{tweet.id}.md",
                          Liquid::Template.parse(tweet_layout).render({
                            'tweet' => {
                              'content' => tweet.text,
                              'id' => tweet.id,
                              'url' => tweet.uri.to_s,
                              'timestamp' => DateTime.parse(tweet.created_at.to_s)
                            }
                          }))
  end

  def tweet_layout
    TWEET_LAYOUT
  end

  private
  def access_token
    @access_token ||= if has_cached_access_token?
                        cached_access_token
                      else
                        TwitterAccessTokenService.new.call
                      end
  end

  def cached_access_token
    {
      token: Settings.twitter.access_token,
      secret: Settings.twitter.access_token_secret
    }
  end

  def has_cached_access_token?
    begin
      Settings.twitter.access_token && Settings.twitter.access_token_secret
    rescue Settingslogic::MissingSetting
    end
  end
end
