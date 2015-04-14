require 'spec_helper'
require 'rspec/its'

require 'byebug'
require 'tweets/tweet_option_parser'

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

      it 'returns an empty struct' do
        expect(options).to eq(OpenStruct.new)
      end
    end

    describe "media file option" do
      let(:long_option)  { '--media' }
      let(:short_option)  { '-m' }
      let(:option_field) { :media_path }
      let(:option_value) { '/tmp/image.png' }

      it_behaves_like 'an option with long and short form'
    end
  end
end
