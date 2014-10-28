require 'liquid'
require 'file_helper'
require 'models/post'
require 'models/page'
require 'models/app_config'

class BuildCommand
  def initialize(dir = Dir.pwd)
    @dir = dir
    @file_helper = FileHelper.new(dir)
  end

  def execute
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
  def config
    @config ||= AppConfig.new(@file_helper.read_file("_config.yml"))
  end

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
      layout = @file_helper.read_file("_layouts/#{ post.vars['layout'] }/#{ template }.liquid")
      post_params = { 'site' => site_config }.merge(params.merge(post.vars))
      post_params['title'] = "#{ post_params['title'] } - #{ config.vars['site']['name'] }"
      @file_helper.mkdir_p("_site#{ post.path }")
      @file_helper.new_file("_site#{ post.permalink }",
               Liquid::Template.parse(layout).render(post_params))
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
    new_tags_index_file("_site/tags.html",
                        "Tag Index - #{ config.vars['site']['name'] }",
                       tags)

    generate_index_per_tag
  end

  def tags_layout
    @layout ||= @file_helper.read_file("_layouts/default/tags.liquid")
  end

  def new_tags_index_file(filename, title, tags)
    @file_helper.new_file(filename,
             Liquid::Template.parse(tags_layout).render({
               'title' => title,
               'tags' => tags,
               'site' => site_config
             }))
  end

  def generate_index_per_tag
    @file_helper.mkdir_p("_site/tags")

    tags.each do |tag|
      new_tags_index_file("_site/tags/#{ tag['name'] }.html",
                          "##{ tag['name'] } - #{ config.vars['site']['name'] }",
                          [tag])
    end
  end

  def generate_homepage
    homepage_posts = posts.sort_by { |p| [p.timestamp, p.title] }.
                           reverse.
                           first(5)

    layout = @file_helper.read_file("_layouts/default/posts.liquid")

    @file_helper.new_file("_site/index.html",
                          Liquid::Template.parse(layout).render({
                            'posts' => homepage_posts,
                            'title' => config.vars['site']['name'],
                            'site' => site_config
                          }))
  end

  def site_config
    {
      "description" => config.site_description,
      "site_map" => config.site_map,
      "user" => config.user
    }
  end

  def cache
    @cache ||= {}
  end

  def template(layout)
    cache[layout.to_sym] ||= @file_helper.read_file("_layouts/#{ layout }/post.liquid")
  end
end
