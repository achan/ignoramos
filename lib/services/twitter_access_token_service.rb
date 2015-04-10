require 'models/settings'
require 'oauth'

class TwitterAccessTokenService
  def call
    request_token.get_access_token(
      :oauth_token => request_token.token,
      :oauth_verifier => request_authorization_pin
    )
  end

  private
  def ask(prompt)
    print "#{prompt}"
    $stdin.gets.strip
  end

  def request_token
    return @request_token if @request_token

    consumer_key = "RerlMuPVgYySMdqvuaBeSw"
    consumer_secret = "Ccq3hS7fMplpjwCfvpVyPQXV6nPGGGonXSAdmi8ZIc"

    consumer = OAuth::Consumer.new(
      consumer_key,
      consumer_secret,
      site: 'https://api.twitter.com'
    )

    @request_token = consumer.get_request_token
  end

  def request_authorization_pin
    Kernel.system('open', authorize_url) ||
      puts("Access here: #{authorize_url}\nand...")

    ask('PIN: ')
  end

  def authorize_url
    @authorize_url ||= request_token.authorize_url(force_login: 'true')
  end
end
