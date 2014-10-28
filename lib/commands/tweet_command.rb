require 'liquid'
require 'models/post'
require 'models/app_config'
require 'twitter'
require 'twitter/tweet'

class TweetCommand
  LAYOUT = <<-LAYOUT
---
title: tweet {{tweet.id}}
timestamp: {{tweet.timestamp}}
layout: tweet
tweet: {{tweet.url}}
---

{{tweet.content}}
LAYOUT

  def initialize(tweet)
    @tweet = tweet
    @dir = Dir.pwd
    @file_helper = FileHelper.new(@dir)
  end

  def execute
    tweet = twitter.update(@tweet)

    @file_helper.new_file("_posts/tweet-#{tweet.id}.md",
                          Liquid::Template.parse(LAYOUT).render({
                            'tweet' => {
                              'content' => @tweet,
                              'id' => tweet.id,
                              'url' => tweet.uri.to_s,
                              'timestamp' => DateTime.now
                            }
                          }))
  end

  private
  def app_config
    @config ||= AppConfig.new(@file_helper.read_file("_config.yml"))
  end

  def twitter
    @twitter ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = "RerlMuPVgYySMdqvuaBeSw"
      config.consumer_secret     = "Ccq3hS7fMplpjwCfvpVyPQXV6nPGGGonXSAdmi8ZIc"
      config.access_token        = app_config.vars['twitter']['access_token']
      config.access_token_secret = app_config.vars['twitter']['access_token_secret']
    end
  end
end
