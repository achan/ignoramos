require './lib/commands/new_command'
require 'fakefs/spec_helpers'
require 'timecop'

shared_examples_for "a command that writes a tweet to file" do
  include FakeFS::SpecHelpers

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

#{tweet}
TWEET
  end

  let(:now) { DateTime.now }
  let(:now_time) { Time.now }

  let(:remote_tweet) do
    double()
  end

  before do
    Timecop.freeze do
      remote_tweet.stub(:uri).and_return(URI(tweet_url))
      remote_tweet.stub(:id).and_return(tweet_id)
      remote_tweet.stub(:created_at).and_return(now_time)
      remote_tweet.stub(:text).and_return(tweet)
      allow_any_instance_of(AppConfig).
          to receive(:vars).and_return({
        'twitter' => { 'access_token' => 'token',
                       'access_token_secret' => 'secret' }
      })

      expect_any_instance_of(Twitter::REST::Client).
          to receive(client_method).with(client_args).and_return(remote_tweet)

      NewCommand.new('testdir').execute
      Dir.chdir('testdir')
      command.execute
      now
    end
  end

  it 'creates new tweet' do
    File.open("_posts/tweet-#{tweet_id}.md", 'r') do |file|
      expect(file.read()).to eq(tweet_post)
    end
  end
end
