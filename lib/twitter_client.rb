require 'services/twitter_access_token_service'
require 'twitter'
require 'twitter/tweet'

class TwitterClient
  def status(tweet_id)
    client.status(tweet_id)
  end

  def update(tweet)
    client.update(tweet)
  end

  def update_with_media(tweet, image)
    client.update_with_media(tweet, image)
  end

  private
  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = "RerlMuPVgYySMdqvuaBeSw"
      config.consumer_secret     = "Ccq3hS7fMplpjwCfvpVyPQXV6nPGGGonXSAdmi8ZIc"
      config.access_token        = access_token.token
      config.access_token_secret = access_token.secret
    end
  end

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
