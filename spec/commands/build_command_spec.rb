require 'fileutils'
require 'commands/build_command'
require 'commands/new_command'

RSpec.describe BuildCommand do
  describe '#execute' do
    let(:test_dir) { 'tmp/testsite' }
    let(:command) { BuildCommand.new(test_dir) }

    before do
      FileUtils.rm_rf(test_dir)
      NewCommand.new(test_dir).execute

      FileUtils.mkdir_p("#{ test_dir }/_includes/default")
      FileUtils.mkdir_p("#{ test_dir }/_layouts/default")
      FileUtils.mkdir_p("#{ test_dir }/rand/dir")

      new_post_file = File.new("#{ test_dir }/rand/dir/test-post.html", 'w')
      new_post_file.write('random data')
      new_post_file.close

      new_post_file = File.new("#{ test_dir }/testfile", 'w')
      new_post_file.write('test data')
      new_post_file.close

      new_post_file = File.new("#{ test_dir }/_includes/default/_header.liquid", 'w')
      new_post_file.write('header {{title}} {{site.description}}')
      new_post_file.close

      new_post_file = File.new("#{ test_dir }/_includes/default/_footer.liquid", 'w')
      new_post_file.write('footer {{title}} {{site.description}}')
      new_post_file.close

      new_post_file = File.new("#{ test_dir }/_includes/default/_post.liquid", 'w')
      new_post_file.write('{{post.html}}{{post.permalink}}')
      new_post_file.close

      new_post_file = File.new("#{ test_dir }/_includes/default/_page.liquid", 'w')
      new_post_file.write('{{page.html}}{{post.permalink}}')
      new_post_file.close

      layout = <<-LAYOUT
{% include 'default/header' %}

{% for tag in tags %}
{{ tag.name }}
{% for post in tag.posts %}
{{ post.title }}
{% endfor %}
{% endfor %}

{% include 'default/footer' %}
LAYOUT

      new_post_file = File.new("#{ test_dir }/_layouts/default/tags.liquid", 'w')
      new_post_file.write(layout)
      new_post_file.close

      layout = <<-LAYOUT
{% include 'default/header' %}

{% for post in posts %}
{% include 'default/post' %}
{% endfor %}

{% include 'default/footer' %}
LAYOUT

      new_post_file = File.new("#{ test_dir }/_layouts/default/posts.liquid", 'w')
      new_post_file.write(layout)
      new_post_file.close

      layout = <<-LAYOUT
{% include 'default/header' %}

{% include 'default/post' %}

{% include 'default/footer' %}
LAYOUT

      new_post_file = File.new("#{ test_dir }/_layouts/default/post.liquid", 'w')
      new_post_file.write(layout)
      new_post_file.close

      layout = <<-LAYOUT
{% include 'default/header' %}

{% include 'default/page' %}

{% include 'default/footer' %}
LAYOUT

      new_post_file = File.new("#{ test_dir }/_layouts/default/page.liquid", 'w')
      new_post_file.write(layout)
      new_post_file.close

      page = <<-POST
---
title: First Page
timestamp: 2014-07-27T00:26:45-04:00
tags: tag1, tag2
permalink: custom-perm
---

Hey page!
POST

      new_post_file = File.new("#{ test_dir }/_pages/hello-world-pt-3.md", 'w')
      new_post_file.write(page)
      new_post_file.close

      page = <<-POST
---
title: First Page
timestamp: 2014-07-27T00:26:45-04:00
tags: tag1, tag2
---

Hey page!
POST

      new_post_file = File.new("#{ test_dir }/_pages/hello-world-pt-2.md", 'w')
      new_post_file.write(page)
      new_post_file.close

      post = <<-POST
---
title: First Post
timestamp: 2014-07-27T00:26:45-04:00
tags: tag1, tag2
---

Hey world!
POST

      new_post_file = File.new("#{ test_dir }/_posts/2014-07-27-hello-world-pt-2.md", 'w')
      new_post_file.write(post)
      new_post_file.close

      post = <<-POST
---
title: Test Post
timestamp: 2014-06-22T00:26:45-04:00
tags: tag2, tag3
---

This is a test post. It's title is {{title}}.
POST

      new_post_file = File.new("#{ test_dir }/_posts/2014-06-22-hello-world.md", 'w')
      new_post_file.write(post)
      new_post_file.close

      post = <<-POST
---
title: Another Test Post
timestamp: 2014-06-22T00:26:45-04:00
tags: tag2, tag3
---

This is a test post. It's title is {{title}}.
POST

      new_post_file = File.new("#{ test_dir }/_posts/2014-06-22-another-world.md", 'w')
      new_post_file.write(post)
      new_post_file.close

      FileUtils.mkdir_p("#{ test_dir }/2014/06/22")
      new_post_file = File.new("#{ test_dir }/2014/06/22/another-test-post.html", 'w')
      new_post_file.write('overridden data')
      new_post_file.close

      command.execute
    end

    describe 'tag index' do
      it 'lists all posts ordered by tags' do
        contents = File.open("#{ test_dir }/_site/tags.html", 'r') do |file|
          file.read()
        end

        actual = <<-ACTUAL
header My First Blog <p>Site description</p>


#tag1

First Post


#tag2

Another Test Post

First Post

Test Post


#tag3

Another Test Post

Test Post



footer My First Blog <p>Site description</p>
  ACTUAL

        expect(contents).to eq(actual)
      end
    end

    describe 'home page' do
      it 'prints the last 5 posts in descending order' do
        contents = File.open("#{ test_dir }/_site/index.html", 'r') do |file|
          file.read()
        end

        actual = <<-ACTUAL
header My First Blog <p>Site description</p>


<p>Hey world!</p>/2014/07/27/first-post.html

<p>This is a test post. It&#39;s title is Test Post.</p>/2014/06/22/test-post.html

<p>This is a test post. It&#39;s title is Another Test Post.</p>/2014/06/22/another-test-post.html


footer My First Blog <p>Site description</p>
  ACTUAL

        expect(contents).to eq(actual)
      end
    end

    it 'drops rendered pages into the _site directory' do
      contents = File.open("#{ test_dir }/_site/first-page.html", 'r') do |file|
        file.read()
      end

      actual = <<-ACTUAL
header First Page <p>Site description</p>

<p>Hey page!</p>

footer First Page <p>Site description</p>
ACTUAL

      expect(contents).to eq(actual)

      contents = File.open("#{ test_dir }/_site/custom-perm.html", 'r') do |file|
        file.read()
      end

      actual = <<-ACTUAL
header First Page <p>Site description</p>

<p>Hey page!</p>

footer First Page <p>Site description</p>
ACTUAL

      expect(contents).to eq(actual)
    end

    it 'drops rendered posts into the _site directory' do
      contents = File.open("#{ test_dir }/_site/2014/07/27/first-post.html", 'r') do |file|
        file.read()
      end

      actual = <<-ACTUAL
header First Post <p>Site description</p>

<p>Hey world!</p>/2014/07/27/first-post.html

footer First Post <p>Site description</p>
ACTUAL

      expect(contents).to eq(actual)

      contents = File.open("#{ test_dir }/_site/2014/06/22/test-post.html", 'r') do |file|
        file.read()
      end

      actual = <<-ACTUAL
header Test Post <p>Site description</p>

<p>This is a test post. It&#39;s title is Test Post.</p>/2014/06/22/test-post.html

footer Test Post <p>Site description</p>
ACTUAL

      expect(contents).to eq(actual)
    end

    context 'custom files' do
      it 'copies all files not in _ folders into _site' do
        contents = File.open("#{ test_dir }/_site/rand/dir/test-post.html", 'r').
                        read
        expect(contents).to eq('random data')

        contents = File.open("#{ test_dir }/_site/testfile", 'r').read
        expect(contents).to eq('test data')
      end

      it 'overrides existing files' do
        contents = File.open("#{ test_dir }/_site/2014/06/22/another-test-post.html", 'r').
                        read
        expect(contents).to eq('overridden data')
      end
    end
  end
end
