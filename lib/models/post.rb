require 'yaml'
require 'liquid'
require 'redcarpet'
require 'time'
require 'rouge'
require 'rouge/plugins/redcarpet'

class Post
  attr_accessor :content
  attr_accessor :vars

  DEFAULT_VARS = {
    'layout' => 'default',
    'markup' => 'ext',
    'timestamp' => DateTime.now
  }

  def initialize(content)
    @content = strip_yaml(content)
    @vars = DEFAULT_VARS.merge(YAML::load(content))
  end

  def permalink
    if @vars.has_key?('permalink')
      "#{ path }/#{ normalize_custom_permalink }.html"
    else
      "#{ path }/#{ slug }.html"
    end
  end

  def slug
    @slug ||= @vars['title'].downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def path
    @path ||= "/#{ date.year }/#{ date.month.to_s.rjust(2, '0') }/#{ date.day.to_s.rjust(2, '0') }"
  end

  def html
    @html ||= Liquid::Template.parse(markdown_to_html).render(@vars)
  end

  def timestamp
    @timestamp ||= @vars['timestamp']
  end

  def title
    @title ||= @vars['title']
  end

  def tags
    @tags ||= @vars['tags'].split(',').map { |x| "##{ x.strip }" }.sort
  end

  def to_liquid
    {
      'html' => html,
      'title' => title,
      'permalink' => permalink,
      'slug' => slug,
      'timestamp' => timestamp,
      'tags' => tags
    }
  end

  protected
  def normalize_custom_permalink
    permalink = @vars['permalink']
    if permalink[0] == '/'
      return permalink[1..-1]
    else
      return permalink
    end
  end

  private
  def strip_yaml(text)
    text.to_s.gsub(/---(.|\n)*---/, '').strip
  end

  def date
    @date ||= timestamp.to_date
  end

  def markdown_to_html
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).
                        render(@content).
                        strip
  end

  class HTML < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end
end
