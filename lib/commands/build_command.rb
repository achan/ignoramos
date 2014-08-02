require 'liquid'
require 'fileutils'
require './lib/models/post'

class BuildCommand
  def initialize(dir = Dir.pwd)
    @dir = dir
  end

  def execute
    Liquid::Template.file_system = Liquid::LocalFileSystem.new("#{ @dir }/_includes")
    FileUtils.rm_rf("#{ @dir }/_site")
    mkdir_p("_site")

    generate_posts
    generate_tag_index
    generate_homepage
  end

  private
  def posts
    @posts ||= load_posts
  end

  def load_posts
    @posts = []

    Dir.foreach("#{ @dir }/_posts") do |item|
      next if item == '.' || item == '..'

      @posts << Post.new(read_file("_posts/#{ item }"))
    end

    @posts
  end

  def generate_posts
    posts.each do |post|
      layout = read_file("_layouts/#{ post.vars['layout'] }/post.liquid")

      mkdir_p("_site#{ post.path }")
      new_file("_site#{ post.slug }.html",
               Liquid::Template.parse(layout).render({
                 'post' => post
               }.merge(post.vars)))
    end
  end

  def tags
    tags = {}
    posts.each do |p|
      p.tags.each do |t|
        tags[t] ||= []
        tags[t] << p
      end
    end

    tags.sort.map do |name, posts|
      { 'name' => name, 'posts' => posts.sort_by { |p| p.title } }
    end
  end

  def generate_tag_index
    layout = read_file("_layouts/default/tags.liquid")

    new_file("_site/tags.html",
             Liquid::Template.parse(layout).render({
               'tags' => tags
             }))
  end

  def generate_homepage
    homepage_posts = posts.sort_by { |p| [p.timestamp, p.title] }.
                           reverse.
                           first(5)

    layout = read_file("_layouts/default/posts.liquid")

    new_file("_site/index.html",
             Liquid::Template.parse(layout).render({
               'posts' => homepage_posts
             }))
  end

  def mkdir_p(dir)
    FileUtils.mkdir_p("#{ @dir }/#{ dir }")
  end

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
