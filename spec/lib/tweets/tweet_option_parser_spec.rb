require 'spec_helper'
require 'rspec/its'

require 'byebug'
require 'tweets/tweet_option_parser'
require 'tweets/status_publisher'
require 'tweets/media_status_publisher'
require 'tweets/status_persister'
require 'tweets/media_status_persister'

describe TweetOptionParser do
  describe "parse" do
    let(:options) { TweetOptionParser.new.parse(argv) }

    subject { options }

    shared_examples_for 'an option with long and short form' do
      context 'when long option is provided' do
        let(:argv) { [long_option, option_value] }

        subject { options }

        it 'assigns the option' do
          expect(options.send(option_field)).to eq(option_value)
        end
      end

      context 'when short option is provided' do
        let(:argv) { [short_option, option_value] }

        it 'tracks the media file' do
          expect(options.send(option_field)).to eq(option_value)
        end
      end
    end

    describe "no options" do
      let(:argv) { nil }

      it 'assigns a StatusPublisher' do
        expect(options.publisher).to be_a(StatusPublisher)
      end

      it 'assigns a StatusPersister' do
        expect(options.persister).to be_a(StatusPersister)
      end
    end

    describe "media file option" do
      let(:long_option)  { '--media' }
      let(:short_option)  { '-m' }
      let(:option_field) { :media_path }
      let(:option_value) { '/tmp/image.png' }

      it_behaves_like 'an option with long and short form'

      describe 'tweet helpers' do
        let(:argv) { [short_option, option_value] }

        it 'assigns a MediaStatusPublisher' do
          publisher = double('MediaStatusPublisher')
          expect(MediaStatusPublisher).
            to receive(:new).with(option_value).and_return(publisher)
          expect(options.publisher).to eq(publisher)
        end

        it 'assigns a MediaStatusPersister' do
          persister = double('MediaStatusPersister')
          expect(MediaStatusPersister).
            to receive(:new).with(option_value).and_return(persister)
          expect(options.persister).to eq(persister)
        end
      end
    end
  end
end
