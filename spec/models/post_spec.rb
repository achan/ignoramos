require './lib/models/post'
require 'fakefs/spec_helpers'

RSpec.describe Post do
  context 'YAML front-matter string provided' do
    let(:content) { File.read('./spec/models/2014-06-22-hello-world.md') }
    let(:post) { Post.new(content) }

    describe '#content' do
      it 'returns post content' do
        expect(post.content).
            to eq('This is a test post. It\'s title is {{title}}.')
      end
    end

    describe '#vars' do
      it 'returns variables from YAML front-matter' do
        expect(post.vars['title']).to eq('Test Post')
        expect(post.vars['markup']).to eq('text')
      end

      it 'falls back to defaults when variables not provided' do
        expect(post.vars['layout']).to eq('post')
      end
    end

    describe '#render' do
      it 'populates variables within the post content' do
        expect(post.render).
            to eq('This is a test post. It\'s title is Test Post.')
      end
    end
  end
end
