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
    @access_token ||= TwitterAccessTokenService.new.call
  end
end
