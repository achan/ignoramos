require 'liquid'
require 'fileutils'
require './lib/models/post'

class BuildCommand
  def execute
    FileUtils.rm_rf('spec/commands/testsite/_site/posts')
    FileUtils.mkdir_p('spec/commands/testsite/_site/posts')

    Dir.foreach('spec/commands/testsite/_posts') do |item|
      next if item == '.' || item == '..'

      filename = item.slice(0, item.rindex('.'))

      new_post = Post.new(read_file("_posts/#{ item }"))

      layout = read_file("_layouts/#{ new_post.vars['layout'] }/post.liquid")

      new_file("_site/posts/#{ filename }.html",
               Liquid::Template.parse(layout).render({ 'post' => { 'content' => new_post.render } }))
    end
  end

  private
  def new_file(filename, contents)
    new_post_file = File.new("spec/commands/testsite/#{ filename }", 'w')
    new_post_file.write(contents)
    new_post_file.close
  end

  def read_file(filename)
    File.open("spec/commands/testsite/#{ filename }", 'r') do |file|
      file.read()
    end
  end

  def cache
    @cache ||= {}
  end

  def template(layout)
    cache[layout.to_sym] ||= File.open("spec/commands/testsite/_layouts/#{ layout }/post.liquid") do |file|
      file.read()
    end
  end
end
