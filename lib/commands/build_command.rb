require 'liquid'
require 'file_helper'
require 'models/post'
require 'models/page'
require 'models/settings'
require 'generators/post_generator'
require 'generators/homepage_generator'
require 'generators/tags_generator'
require 'filters/markdown_filter'

class BuildCommand
  def initialize(dir = Dir.pwd)
    @dir = dir
    @file_helper = FileHelper.new(dir)
  end

  def execute
    Liquid::Template.register_filter(MarkdownFilter)
    Liquid::Template.file_system = Liquid::LocalFileSystem.new("#{ @dir }/_includes")
    FileUtils.rm_rf("#{ @dir }/_site")
    @file_helper.mkdir_p("_site")

    generate_pages
    generate_posts
    generate_tags_index
    generate_homepage

    copy_custom_files
  end

  private
  def copy_custom_files
    custom_files.each { |fn| copy_into_site(fn) }
  end

  def copy_into_site(filename)
    destination = sandbox_filename(filename)

    if File.directory?(filename)
      destination = destination.slice(0..(destination.rindex('/')))
    end

    FileUtils.cp_r(filename, destination)
  end

  def sandbox_filename(filename)
    filename.gsub(@dir, "#{ @dir }/_site")
  end

  def custom_files
    @custom_files ||= Dir.glob("#{@dir}/[^_]*")
  end

  def posts
    @posts ||= load_posts
  end

  def pages
    @pages ||= load_posts('_pages') { |contents| Page.new(contents) }
  end

  def load_posts(dir='_posts', &block)
    posts = []

    Dir.foreach("#{ @dir }/#{ dir }") do |item|
      next if item == '.' || item == '..'

      contents = @file_helper.read_file("#{ dir }/#{ item }")
      posts << if block_given?
        yield contents
      else
        Post.new(contents)
      end
    end

    posts
  end

  def generate_pages
    generate_dir(pages, 'page') { |p| { 'page' => p } }
  end

  def generate_posts
    generate_dir(posts, 'post') { |p| { 'post' => p } }
  end

  def generate_dir(posts, template, &block)
    posts.each do |post|
      params = yield post
      PostGenerator.new(post, template, params, @file_helper).generate
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

  def generate_tags_index
    TagsGenerator.new(tags, @file_helper).generate
  end

  def generate_homepage
    HomepageGenerator.new(posts, @file_helper).generate
  end

  def html(markdown)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(markdown).strip
  end
end
