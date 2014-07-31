require 'liquid'
require 'fileutils'
require './lib/models/post'

class BuildCommand
  def initialize(dir = Dir.pwd)
    @dir = dir
  end

  def execute
    Liquid::Template.file_system = Liquid::LocalFileSystem.new("#{ @dir }/_includes")
    FileUtils.rm_rf("#{ @dir }/_site/posts")
    FileUtils.mkdir_p("#{ @dir }/_site/posts")

    Dir.foreach("#{ @dir }/_posts") do |item|
      next if item == '.' || item == '..'

      filename = item.slice(0, item.rindex('.'))

      new_post = Post.new(read_file("_posts/#{ item }"))

      layout = read_file("_layouts/#{ new_post.vars['layout'] }/post.liquid")

      new_file("_site/posts/#{ filename }.html",
               Liquid::Template.parse(layout).render({
                 'post' => { 'content' => new_post.render }
               }.merge(new_post.vars)))
    end
  end

  private
  def new_file(filename, contents)
    new_post_file = File.new("#{ @dir }/#{ filename }", 'w')
    new_post_file.write(contents)
    new_post_file.close
  end

  def read_file(filename)
    File.open("#{ @dir }/#{ filename }", 'r') do |file|
      file.read()
    end
  end

  def cache
    @cache ||= {}
  end

  def template(layout)
    cache[layout.to_sym] ||= read_file("_layouts/#{ layout }/post.liquid")
  end
end
