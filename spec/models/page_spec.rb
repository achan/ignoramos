require 'models/page'

RSpec.describe Page do
  let(:content) do
    <<-CONTENT
---
title: Test Post
timestamp: 2014-06-22T00:15:50-04:00
tags: test, beginning, randomtag
---

This is a test post. It is title is {{title}}.
CONTENT
  end

  let(:page) { Page.new(content) }

  describe '#permalink' do
    context 'not provided' do
      it 'consists of just the slug' do
        expect(page.permalink).to eq('/test-post.html')
      end
    end

    context 'provided in yaml' do
      let(:custom_permalink_content) do
         <<-CONTENT
---
title: Test Post
timestamp: 2014-06-22T00:15:50-04:00
tags: test, beginning, randomtag
permalink: custom-permalink
---

This is a test post. It is title is {{title}}.
CONTENT
      end

      let (:custom_permalink_page) { Page.new(custom_permalink_content) }

      it 'uses the permalink provided from yaml' do
        expect(custom_permalink_page.permalink).to eq('/custom-permalink.html')
      end
    end
  end
end
