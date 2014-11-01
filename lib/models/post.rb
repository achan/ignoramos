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
    @vars = DEFAULT_VARS.merge(YAML::load(content) || {})
  end

  def permalink
    if @vars.has_key?('permalink')
      "#{ path }/#{ normalize_custom_permalink }.html"
    else
      "#{ path }/#{ slug }.html"
    end
  end

  def slug
    return '' unless @vars['title']
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
    return [] unless @vars['tags']
    @tags ||= @vars['tags'].split(',').map { |x| x.strip }.sort
  end

  def external_link
    @external_link ||= @vars['external_link']
  end

  def title_link
    @title_link ||= if has_external_link?
        external_link
      else
        permalink
      end
  end

  def post_type
    @post_type ||= has_external_link? ? :link_post : :self_post
  end

  def to_liquid
    @vars.merge({
      'html' => html,
      'title' => title,
      'permalink' => permalink,
      'slug' => slug,
      'timestamp' => timestamp.iso8601,
      'tags' => tags,
      'external_link' => external_link,
      'post_type' => post_type.to_s,
      'title_link' => title_link
    })
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
  def post_vars
  end

  def has_external_link?
    !external_link.nil?
  end

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
