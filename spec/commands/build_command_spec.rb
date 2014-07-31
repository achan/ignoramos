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

      layout = <<-LAYOUT
{% include 'default/header' %}

{{ post.content }}

{% include 'default/footer' %}
LAYOUT

      new_post_file = File.new("#{ test_dir }/_layouts/default/post.liquid", 'w')
      new_post_file.write(layout)
      new_post_file.close

      post = <<-POST
---
title: First Post
---

Hey world!
POST

      new_post_file = File.new("#{ test_dir }/_posts/2014-07-27-hello-world-pt-2.md", 'w')
      new_post_file.write(post)
      new_post_file.close

      post = <<-POST
---
title: Test Post
---

This is a test post. It's title is {{title}}.
POST

      new_post_file = File.new("#{ test_dir }/_posts/2014-06-22-hello-world.md", 'w')
      new_post_file.write(post)
      new_post_file.close

      command.execute
    end

    it 'drops rendered posts into the posts directory' do
      contents = File.open("#{ test_dir }/_site/posts/2014-07-27-hello-world-pt-2.html", 'r') do |file|
        file.read()
      end

      actual = <<-ACTUAL
header First Post

<p>Hey world!</p>

footer First Post
ACTUAL

      expect(contents).to eq(actual)

      contents = File.open("#{ test_dir }/_site/posts/2014-06-22-hello-world.html", 'r') do |file|
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
