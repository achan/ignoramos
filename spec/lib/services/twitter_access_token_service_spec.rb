require 'spec_helper'
require 'services/twitter_access_token_service'
require 'byebug'

describe TwitterAccessTokenService do
  describe '#call' do
    let(:service_call) { TwitterAccessTokenService.new.call }

    let(:settings) do
      Settingslogic.new('site' => { 'name' => 'My First Blog',
                                    'tagline' => 'Test tagline',
                                    'description' => 'Site description',
                                    'user' => 'Test user',
                                    'site_map' => '',
                                    'post_limit' => 3 })
    end

    let(:consumer) do
      double(:consumer, get_request_token: double(:request_token))
    end

    let(:token) { 'abcdef' }
    let(:request_token) { double(:request_token, token: token) }
    let(:pin) { 'secretpin' }
    let(:access_token) { double(:token, token: '12345', secret: '09876') }
    let(:authorize_url) { 'http://api.twitter.com/authorize' }

    before do
      allow_any_instance_of(OAuth::Consumer).
        to receive(:get_request_token).and_return(request_token)

      allow(request_token).
        to receive(:authorize_url).with(force_login: 'true').
                                   and_return(authorize_url)

      allow(request_token).
        to receive(:get_access_token).with(oauth_token: token, oauth_verifier: pin).
                                      and_return(access_token)

      allow($stdin).to receive(:gets).and_return(pin)

      allow(Kernel).to receive(:system).with('open', authorize_url)
    end

    it 'returns a token from twitter' do
      expect(service_call).to eq(access_token)
    end
  end
end
