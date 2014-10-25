require './lib/commands/new_command'
require './lib/commands/tweet_command'
require 'fakefs/spec_helpers'
require 'timecop'

RSpec.describe TweetCommand do
  describe '#execute' do
    include FakeFS::SpecHelpers

    let(:command) { TweetCommand.new('testdir') }
    let(:tweet) { 'this is a tweet' }
    let(:tweet_id) { '525483671584002048' }
    let(:tweet_url) { "https://twitter.com/amoschan/status/#{tweet_id}" }
    let(:tweet_post) do
<<-TWEET
---
title: tweet #{tweet_id}
timestamp: #{now}
layout: tweet
tweet: #{tweet_url}
---

this is a tweet
TWEET
    end

    let(:now) { DateTime.now }

    let(:created_tweet) do
      double()
    end

    before do
      created_tweet.stub(:uri).and_return(URI(tweet_url))
      created_tweet.stub(:id).and_return(tweet_id)
      allow_any_instance_of(AppConfig).
          to receive(:vars).and_return({
        'twitter' => { 'access_token' => 'token',
                       'access_token_secret' => 'secret' }
      })

      expect_any_instance_of(Twitter::REST::Client).
          to receive(:update).with(tweet).and_return(created_tweet)

      Timecop.freeze do
        NewCommand.new('testdir').execute
        Dir.chdir('testdir')
        TweetCommand.new('this is a tweet').execute
        now
      end
    end

    it 'creates new tweet' do
      File.open("_posts/tweet-#{tweet_id}.md", 'r') do |file|
        expect(file.read()).to eq(tweet_post)
      end
    end
  end
end
