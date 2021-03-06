require 'models/post'

RSpec.describe Post do
  context 'YAML front-matter string provided' do
    let(:content) do
      <<-CONTENT
---
title: Test Post
markup: text
timestamp: 2014-06-22T00:15:50-04:00
tags: test, beginning, randomtag
---

This is a test post. It is title is {{title}}.
CONTENT
    end

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

    describe '#permalink' do
      it 'returns the permalink' do
        expect(post.permalink).to eq('/2014/06/22/test-post.html')
      end
    end

    describe '#slug' do
      it 'returns the slugified title' do
        expect(post.slug).to eq('test-post')
      end
    end

    describe '#path' do
      it 'returns the directory the post belongs in' do
        expect(post.path).to eq('/2014/06/22')
      end
    end

    describe '#html' do
      it 'populates variables within the post content' do
        expect(post.html).
            to eq('<p>This is a test post. It is title is Test Post.</p>')
      end
    end

    describe '#tags' do
      it 'returns the alphatical list of tags associated to post' do
        expect(post.tags).to eq(['beginning', 'randomtag', 'test'])
      end
    end

    describe '#external_link' do
      it 'returns nil' do
        expect(post.external_link).to be_nil
      end
    end

    describe '#title_link' do
      it 'returns the permalink' do
        expect(post.title_link).to eq('/2014/06/22/test-post.html')
      end
    end

    describe '#post_type' do
      it 'returns :self_post' do
        expect(post.post_type).to eq(:self_post)
      end
    end
  end

  context 'permalink provided' do
    let(:content) do
      <<-CONTENT
---
title: Test
permalink: custom-permalink
timestamp: 2014-06-22T00:15:50-04:00
external_link: http://nba.com
---

This is a test.
CONTENT
    end

    let(:post) { Post.new(content) }

    describe "#permalink" do
      it 'uses the custom permalink' do
        expect(post.permalink).to eq('/2014/06/22/custom-permalink.html')
      end
    end

    describe "#tags" do
      it 'returns [] if none provided' do
        expect(post.tags).to eq([])
      end
    end

    describe '#external_link' do
      it 'returns the external link' do
        expect(post.external_link).to eq('http://nba.com')
      end
    end

    describe '#title_link' do
      it 'returns the external link' do
        expect(post.title_link).to eq('http://nba.com')
      end
    end

    describe '#post_type' do
      it 'returns :link_post' do
        expect(post.post_type).to eq(:link_post)
      end
    end
  end

  context 'Markdown rendering' do
    let(:content) do
      <<-CONTENT
---
title: Markdown Test
---

This is a **Markdown test**.
CONTENT
    end

    let(:post) { Post.new(content) }

    describe "#html" do
      it 'renders markdown' do
        expect(post.html).
            to eq('<p>This is a <strong>Markdown test</strong>.</p>')
      end
    end
  end
end
