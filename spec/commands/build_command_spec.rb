require 'fileutils'
require './lib/commands/build_command'
require './lib/commands/new_command'

RSpec.describe BuildCommand do
  describe '#execute' do
    let(:test_dir) { 'tmp/testsite' }
    let(:command) { BuildCommand.new(test_dir) }

    before do
      FileUtils.rm_rf(test_dir)
      NewCommand.new(test_dir).execute

      FileUtils.mkdir_p("#{ test_dir }/_includes/default")
      FileUtils.mkdir_p("#{ test_dir }/_layouts/default")

      new_post_file = File.new("#{ test_dir }/_includes/default/_header.liquid", 'w')
      new_post_file.write('header {{title}}')
      new_post_file.close

      new_post_file = File.new("#{ test_dir }/_includes/default/_footer.liquid", 'w')
      new_post_file.write('footer {{title}}')
      new_post_file.close

      new_post_file = File.new("#{ test_dir }/_includes/default/_post.liquid", 'w')
      new_post_file.write('{{post.html}}')
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

      command.execute
    end

    describe 'tag index' do
      it 'lists all posts ordered by tags' do
        contents = File.open("#{ test_dir }/_site/tags.html", 'r') do |file|
          file.read()
        end

        actual = <<-ACTUAL
header 


tag1

First Post


tag2

First Post

Test Post


tag3

Test Post



footer 
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
header 


<p>Hey world!</p>

<p>This is a test post. It&#39;s title is Test Post.</p>


footer 
  ACTUAL

        expect(contents).to eq(actual)
      end
    end

    it 'drops rendered posts into the _site directory' do
      contents = File.open("#{ test_dir }/_site/2014/07/27/first-post.html", 'r') do |file|
        file.read()
      end

      actual = <<-ACTUAL
header First Post

<p>Hey world!</p>

footer First Post
ACTUAL

      expect(contents).to eq(actual)

      contents = File.open("#{ test_dir }/_site/2014/06/22/test-post.html", 'r') do |file|
        file.read()
      end

      actual = <<-ACTUAL
header Test Post

<p>This is a test post. It&#39;s title is Test Post.</p>

footer Test Post
ACTUAL

      expect(contents).to eq(actual)
    end
  end
end
