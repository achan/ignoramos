require './lib/models/post'
require 'fakefs/spec_helpers'

RSpec.describe Post do
  context 'YAML front-matter string provided' do
    let(:content) { File.read('./spec/models/2014-06-22-hello-world.md') }
    let(:post) { Post.new(content) }

    describe '#content' do
      it 'returns post content' do
        expect(post.content).
            to eq('This is a test post. It is title is {{title}}.')
      end
    end

    describe '#vars' do
      it 'returns variables from YAML front-matter' do
        expect(post.vars['title']).to eq('Test Post')
        expect(post.vars['markup']).to eq('text')
      end

      it 'falls back to defaults when variables not provided' do
        expect(post.vars['layout']).to eq('default')
      end
    end

    describe '#slug' do
      it 'returns the slugified title' do
        expect(post.slug).to eq('/2014/06/22/test-post')
      end
    end

    describe 'path' do
      it 'returns the directory the post belongs in' do
        expect(post.path).to eq('/2014/06/22')
      end
    end

    describe '#render' do
      it 'populates variables within the post content' do
        expect(post.render).
            to eq('<p>This is a test post. It is title is Test Post.</p>')
      end
    end
  end

  context 'Markdown rendering' do
    let(:content) { File.read('./spec/models/2014-07-29-markdown-test.md') }
    let(:post) { Post.new(content) }

    describe "#render" do
      it 'renders markdown' do
        expect(post.render).
            to eq('<p>This is a <strong>Markdown test</strong>.</p>')
      end
    end
  end
end
